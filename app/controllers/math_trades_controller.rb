class MathTradesController < ApplicationController
	include MathTradesHelper
	include BoardGameGem
		
	before_filter :load_trade, :validate_access, except: [:new, :index, :create]
	
	before_filter :validate_ownership, only: [:confirm_delete, :edit, :update, :status, :save_status, :upload]
	before_filter :validate_ownership_with_deleted, only: [:destroy]
	before_filter :validate_is_before_wants_deadline, only: [:save_wantlist, :confirm_wants]
	before_filter :validate_can_view_results, only: [:results]
	before_filter :validate_trade_is_not_finalized, only: [:edit, :update, :confirm_delete, :destroy, :status, :save_status, :upload, :save_wantlist, :confirm_wants]
	
	def index
		@trades = MathTrade.filter_by(params[:filter], current_user)
	end
	
	def new
		@trade = MathTrade.new
		if !current_user.verified?
			show_error 'You must validate your BGG account to start a math trade.'
		end
	end
	
	def show
	end
	
	def results
	end
	
	def raw_results
	end
	
	def who_wanted_mine
	end
	
	def generate_wantlist
		render plain: @trade.generate_wantlist
	end
	
	def wantlist
		@wantlist = @trade.get_user_wantlist(current_user).map do |x|
			hash = x.as_json
			hash[:bgg_item_data] = x.item.bgg_item
			hash[:alt_name] = x.item.alt_name
			hash[:item_id] = x.item.id
			hash[:want_values] = x.want_items.pluck(:math_trade_item_id)
			hash
		end
		
		
		@items = @trade.items_from_user(current_user).map do |x|
			hash = x.as_json
			hash[:bgg_item_data] = x.bgg_item_id != -1 ? x.bgg_item : nil
			hash
		end
		
		@groups = @trade.get_user_groups(current_user).map do |x|
			hash = x.as_json
			hash[:want_values] = x.want_items.pluck(:math_trade_item_id)
			hash[:want_links] = x.want_links.pluck(:math_trade_want_id)
			hash[:is_group] = true
			hash
		end
	end
	
	def confirm_delete
	end
	
	def status
	end
	
	def upload
	end
	
	def edit
	end
	
	def create
		params[:math_trade][:moderator_id] = current_user.id
		params[:math_trade][:offer_deadline] = params[:math_trade][:offer_deadline].to_time
		params[:math_trade][:wants_deadline] = params[:math_trade][:wants_deadline].to_time

		@trade = MathTrade.new(trade_params)
		if @trade.save
			redirect_to @trade
		else
			render "new"
		end
	end
	
	def update
		if @trade.moderator_id != current_user.id
			render :unauthorized
		end
		if @trade.update_attributes(trade_params)
			redirect_to @trade
		else
			render "edit"
		end
	end
	
	def save_status
		case params[:status]
		when "finalized"
			if @trade.results_list.nil? 
				show_error "Trade cannot be finalized until a results list has been uploaded.", math_trade_path(@trade)
			end
			@trade.finalized_at = DateTime.now
		when "pending"
			if @trade.results_list.nil?
				show_error "Trade cannot be pending until a results list has been uploaded.", math_trade_path(@trade)
			end
		end
		
		@trade.status = params[:status]
		@trade.save
		flash[:notice] = @trade.name + " set to " + @trade.status + " mode."
		redirect_to math_trade_path(@trade)
	end
	
	def upload_results
		@trade.results_list = params[:math_trade][:results_list].read
		@trade.save
		flash[:notice] = "Results uploaded."
		redirect_to status_math_trade_path(@trade)
	end
	
	def confirm_wants
		@trade.math_trade_want_confirmations.create(user_id: current_user.id)
		render json: { error: false, message: "Saved successfully." }	
	end
	
	def destroy
		@trade.destroy
		flash[:message] = "Trade deleted successfully."
		redirect_to root_path
	end
		
	def retrieve_items
		items = @trade.items.includes(:wants, :bgg_item, :user, user: :bgg_user_data)
		collection = current_user.get_collection
		
		# Retrieve all the items in the list
		item_ids = items.pluck(&:bgg_item_id).select { |x| x != -1 }
		
		# Retrieve all the want data
		want_data = MathTradeWant.joins("LEFT JOIN math_trade_want_items ON math_trade_want_items.math_trade_want_id = math_trade_wants.id")
			.where(math_trade_id: @trade.id, user_id: current_user.id)
			.select('math_trade_want_items.math_trade_item_id AS want_id, math_trade_wants.math_trade_item_id AS item_id').group_by(&:item_id)
					
		items = items.map do |x| 
			hash = x.as_json
			hash[:bgg_user_data] = x.user.bgg_user_data
			hash[:linked_items] = x.get_linked_items
			hash[:bgg_item_data] = x.bgg_item
			hash[:want_data] = want_data[x.id] ? want_data[x.id].map { |x| x.want_id }.compact : nil
			hash[:collection] = collection.status_of(x.bgg_item_id)
			hash
		end
		
		if params[:filter]
			items = case params[:filter]
			when "wishlist"
				items.select { |x| !x[:bgg_item_data].nil? && !x[:bgg_item_data][:collection].nil? && x[:bgg_item_data][:collection][:wishlist] }
			when "wantintrade"
				items.select { |x| !x[:bgg_item_data].nil? && !x[:bgg_item_data][:collection].nil? && x[:bgg_item_data][:collection][:want] }
			when "wanttobuy"
				items.select { |x| !x[:bgg_item_data].nil? && !x[:bgg_item_data][:collection].nil? && x[:bgg_item_data][:collection][:want_to_buy] }
			when "owned"
				items.select { |x| !x[:bgg_item_data].nil? && !x[:bgg_item_data][:collection].nil? && x[:bgg_item_data][:collection][:own] }	
			when "me"
				items.select { |x| x["user_id"] == current_user.id }
			when "giftcertificate"
				items.select do |x| 
					item_matches_phrases(x, ["gift card", "giftcard", "gift certificate", "giftcertificate", "gc"])
				end
			when "geekgold"
				items.select do |x| 
					item_matches_phrases(x, ["geek gold", "geekgold", "gg ", " gg"])
			end
			when "cash"
				items.select do |x|
					item_matches_phrases(x, ["$", "usd", "dollar", "cash"])
				end
			else
				items
			end	
		end
		render json: items
	end
	
	def save_wantlist
		grid = params[:grid]
		wants_found = []
		want_groups_found = []
		want_links_found = {}
		grid.each do |want|
			is_group = want[1][:is_group] == "true"
			if is_group
				@want = WantGroup.find(want[1][:id].to_i)
			else
				@want = MathTradeWant.find(want[1][:id].to_i)
			end
			
			want_items_found = []
			want[1][:items].each do |item|
				state = item[1][:state] == "true"
				is_group_item = item[1][:is_group] == "true"
				if is_group_item
					@item = WantGroup.find(item[1][:id].to_i)
					want_links_found[@item] = [] if want_links_found[@item].nil?
				end
				if state
					if !is_group_item
						if is_group
							@want.want_items.find_or_create_by(want_group_id: @want.id, math_trade_item_id: item[1][:id].to_i)
						else
							@want.want_items.find_or_create_by(math_trade_want_id: @want.id, math_trade_item_id: item[1][:id].to_i)
						end
						want_items_found.push(item[1][:id].to_i)
					else
						if !is_group
							@item.want_links.find_or_create_by(want_group_id: @item.id, math_trade_want_id: @want.id)
							want_links_found[@item].push(@want.id)
						end
					end
				end
			end
			
			@want.want_items.where.not({ math_trade_item_id: want_items_found }).destroy_all
			
			if is_group
				want_groups_found.push(want[1][:id].to_i)
			else
				wants_found.push(want[1][:id].to_i)
			end
		end
		
		want_links_found.each do |key, value|
			key.want_links.where.not({ math_trade_want_id: value }).destroy_all
			#@want.want_links.where.not({ math_trade_item_id: want_links_founds }).destroy_all
		end
		
		@trade.get_user_wantlist(current_user).where.not({ id: wants_found }).destroy_all
		@trade.get_user_groups(current_user).where.not({ id: want_groups_found }).destroy_all
		
		render json: { error: false, message: "Saved successfully." }
	end
	
	
	private
	
	def load_trade
		@trade = MathTrade.find_by_id(params[:id])
	end
	
	def item_matches_phrases(item, phrases)
		phrases.any? do |word|
			(!item["alt_name"].nil? && item["alt_name"].downcase.include?(word)) || item["description"].downcase.include?(word) 
		end
	end
	
	def trade_params
		params.require(:math_trade).permit(:name, :moderator_id, :description, :offer_deadline, :wants_deadline, :shipping, :discussion_thread)
	end

	def validate_ownership(with_deleted = false)
		@trade = (with_deleted ? MathTrade.with_deleted : MathTrade).find(params[:id])
		if @trade.moderator_id != current_user.id
			show_error "You are not authorized to administer this trade."
		end
	end
	
	def validate_ownership_with_deleted
		validate_ownership(true)
	end
	
	def validate_is_before_wants_deadline
		if @trade.wants_due?
			show_error "This trade is no longer accepting wantlists.", math_trade_path(@trade)
		end
	end
	
	def validate_access
		if @trade.status == "draft" && @trade.moderator_id != current_user.id
			show_error "This trade is set to private.", math_trades_path
		end
	end
	
	def validate_can_view_results
		if !@trade.can_view_results(current_user)
			show_error "This trade does not have any results uploaded yet, or you do not have permission to view them.", math_trade_path(@trade)
		end
	end
	
	def validate_trade_is_not_finalized
		if @trade.status == "finalized"
			show_error "This trade has been finalized, and is not allowing any further changes.", math_trade_path(@trade)
		end
	end
	
	def add_bgg_data_to_hash(hash, bgg_item_data)
		if !bgg_item_data.nil?
		collection_data = current_user.get_item_from_collection(bgg_item_data.id)
			hash[:bgg_item_data] = {
				type: bgg_item_data.type,
				thumbnail: bgg_item_data.thumbnail,
				name: bgg_item_data.name,
				year_published: bgg_item_data.year_published,
				min_players: bgg_item_data.min_players,
				max_players: bgg_item_data.max_players,
				playing_time: bgg_item_data.playing_time,
				collection: collection_data && collection_data.length > 0 ? collection_data[0].status : nil
			}
			if !bgg_item_data.statistics.nil?
				hash[:bgg_item_data][:statistics] = {
					average: bgg_item_data.statistics[:average],
					bayes: bgg_item_data.statistics[:bayes],
					owned: bgg_item_data.statistics[:owned],
					trading: bgg_item_data.statistics[:trading],
					wanting: bgg_item_data.statistics[:wanting],
					wishing: bgg_item_data.statistics[:wishing],
					weight: bgg_item_data.statistics[:average_weight],
					rank: bgg_item_data.statistics[:ranks][0]
				}
			end
		else
			hash[:bgg_item_data] = nil
		end
		return hash
	end
end
