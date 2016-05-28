class MathTradeItemsController < ApplicationController
	before_filter :load_trade
	before_filter :validate_is_before_offers_deadline, only: [:new, :edit, :create, :update, :destroy, :show_copy_from_previous_trade, :copy_from_previous_trade]
	before_filter :validate_trade_is_active, only: [:new, :edit, :create, :update, :destroy, :show_copy_from_previous_trade, :copy_from_previous_trade]

	def index
	end
	
	def show
		@item = MathTradeItem.find(params[:id])
		@bgg_item = @item.to_bgg_item
	end
	
	def new
    @item = MathTrade.find(params[:math_trade_id]).items.build
	end
	
	def show_copy_from_previous_trade
		@previous_trades = MathTrade.where(status: 3) #should be finalized
			.where(["created_at < ?", @trade.created_at]).includes(:items)
			.order(created_at: :desc).select { |x| x.is_user_in_trade?(current_user) }
		@items_for_user = @trade.items_from_user(current_user)
	end
	
	def edit
		@item = MathTradeItem.find(params[:id])
		if @item.user.id != current_user.id
			render :unauthorized
		end
	end
	
	def copy_from_previous_trade

		old_trade = MathTrade.find(params[:copy_from_id])
		old_trade.items_from_user(current_user).select { |x| !x.did_trade }.each do |item|
			new_item = item.clone
			new_item.math_trade_id = @trade.id
			new_item.save
		end
		flash[:message] = "Items added!"
		redirect_to @trade
	end
	
	def create
		params[:math_trade_item][:math_trade_id] = params[:math_trade_id]
		params[:math_trade_item][:user_id] = current_user.id
		@item = MathTradeItem.new(item_params)
		if @item.save
			redirect_to [@item.math_trade, @item]
		else
			render "new"
		end
	end
	
	def update
		@item = MathTradeItem.find(params[:id])
		if @item.update_attributes(item_params)
			redirect_to [@item.math_trade, @item]
		else
			render "edit"
		end
	end
	
	def destroy
		@item = MathTradeItem.find(params[:id])
		if @item.user.id != current_user.id
			render :unauthorized
		end
		if @item != nil
			@item.delete
		end
		
		redirect_to @item.math_trade
	end
	
	private
	
	def item_params
		params.require(:math_trade_item).permit(:bgg_item_id, :user_id, :math_trade_id, :description, :alt_name)
	end
	
	def load_trade
		@trade = MathTrade.find(params[:math_trade_id])
	end
	
	def validate_is_before_offers_deadline
		if @trade.offers_due? 
			show_error "This trade is no longer accepting offers.", math_trade_path(@trade)
		end
	end
	
	def validate_trade_is_active
		if @trade.status != "active"
			show_error "This trade is not accepting submissions at this time.", math_trade_path(@trade)
		end
	end
end
