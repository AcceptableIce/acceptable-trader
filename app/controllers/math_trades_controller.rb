class MathTradesController < ApplicationController
	before_filter :validate_ownership, only: [:confirm_delete, :edit, :update]
	before_filter :validate_ownership_with_deleted, only: [:destroy]
	
	def index
		@trades = MathTrade.where(status: "active")
	end
	
	def new
		@trade = MathTrade.new
		if !current_user.verified?
			show_error 'You must validate your BGG account to start a math trade.'
		end
	end
	
	def show
		@trade = MathTrade.find_by_id(params[:id])
	end
	
	def wantlist
		@trade = MathTrade.find_by_id(params[:id])
		@wantlist = @trade.get_user_wantlist(current_user).includes(:item).map do |x|
			hash = x.as_json
			bgg_item_data = BggHelper.get_item(x.item.bgg_item)
			hash = add_bgg_data_to_hash(hash, bgg_item_data)
			hash[:alt_name] = x.item.alt_name
			hash[:item_id] = x.item.id
			hash[:want_values] = x.want_items.pluck(:math_trade_item_id)
			hash
		end
		
		@items = @trade.items_from_user(current_user).map do |x|
			hash = x.as_json
			if x[:bgg_item] != -1 
				bgg_item_data = BggHelper.get_item(x[:bgg_item])
				hash = add_bgg_data_to_hash(hash, bgg_item_data)
			else
				hash[:bgg_item_data] = nil
			end
			hash
		end
	end
	
	def confirm_delete
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
		@trade = MathTrade.find_by_id(params[:id])
		if @trade.moderator_id != current_user.id
			render :unauthorized
		end
		if @trade.update_attributes(trade_params)
			redirect_to @trade
		else
			render "edit"
		end
	end
	
	def destroy
		@trade.destroy
		flash[:message] = "Trade deleted successfully."
		redirect_to root_path
	end
		
	def retrieve_items
		@trade = MathTrade.find_by_id(params[:id])
		items = @trade.items.includes(:wants)
		items = items.map do |x| 
			hash = x.as_json
			hash[:bgg_user_data] = x.user.bgg_user
			hash[:linked_items] = x.get_linked_items
			if x[:bgg_item] != -1 
				bgg_item_data = BggHelper.get_item(x[:bgg_item])
				hash = add_bgg_data_to_hash(hash, bgg_item_data)
			else
				hash[:bgg_item_data] = nil
			end
			want_data = x.wants.joins(:want_items).where(user_id: current_user.id).pluck(:'math_trade_want_items.math_trade_item_id')
			hash[:want_data] = x.wants.any? ? want_data : nil
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
					item_matches_phrases(x, ["gift card", "giftcard", "gift certificate", "giftcertificate"])
				end
			when "geekgold"
				items.select do |x| 
					item_matches_phrases(x, ["geek gold", "geekgold", "gg"])
			end
			when "cash"
				items.select do |x|
					item_matches_phrases(x, ["$", "usd", "dollar"])
				end
			else
				items
			end	
		end
		render json: items
	end
	
	def save_wantlist
		@trade = MathTrade.find(params[:id])
		grid = params[:grid]
		wants_found = []
		grid.each do |want|
			@want = MathTradeWant.find(want[1][:id].to_i)
			want_items_found = []
			want[1][:items].each do |item|
				state = item[1][:state] == "true"
				if state
					@want.want_items.find_or_create_by(math_trade_want_id: @want.id, math_trade_item_id: item[1][:id].to_i)
					want_items_found.push(item[1][:id].to_i)
				end
			end
			@want.want_items.where.not({ math_trade_item_id: want_items_found }).destroy_all
			wants_found.push(want[1][:id].to_i)
		end
		@trade.get_user_wantlist(current_user).where.not({ id: wants_found }).destroy_all
		render json: { error: false, message: "Saved successfully." }
	end
	
	
	private
	
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
				statistics: {
					average: bgg_item_data.statistics[:average],
					bayes: bgg_item_data.statistics[:bayes],
					owned: bgg_item_data.statistics[:owned],
					trading: bgg_item_data.statistics[:trading],
					wanting: bgg_item_data.statistics[:wanting],
					wishing: bgg_item_data.statistics[:wishing],
					weight: bgg_item_data.statistics[:average_weight],
					rank: bgg_item_data.statistics[:ranks][0]
				},
				collection: collection_data.length > 0 ? collection_data[0].status : nil
			}
		else
			hash[:bgg_item_data] = nil
		end
		return hash
	end
	
	def item_matches_phrases(item, phrases)
		phrases.any? do |word|
			(!item["alt_name"].nil? && item["alt_name"].downcase.include?(word)) || item["description"].downcase.include?(word) 
		end
	end
	
	def trade_params
		params.require(:notice).permit(:name, :moderator_id, :description, :offer_deadline, :wants_deadline, :shipping, :discussion_thread)
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
end
