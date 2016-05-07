class MathTradesController < ApplicationController
	def index
		
	end
	
	def new
		@trade = MathTrade.new
		if !current_user.validated?
			render :unauthorized
		end
	end
	
	def show
		@trade = MathTrade.find_by_id(params[:id])
	end
	
	def edit
		@trade = MathTrade.find_by_id(params[:id])
		if @trade.moderator_id != current_user.id
			render :unauthorized
		end
	end
	
	def create
		params[:math_trade][:moderator_id] = current_user.id
		@trade = MathTrade.new(trade_params)
		if @trade.save
			redirect_to @trade
		else
			render "new"
		end
	end
	
	def update
		@trade = MathTrade.find_by_id(params[:id])
		if @trade.update_attributes(trade_params)
			redirect_to @trade
		else
			render "edit"
		end
	end
	
	private
	
	def trade_params
		params.require(:math_trade).permit(:name, :moderator_id, :description, :offer_deadline, :wants_deadline, :shipping, :discussion_thread)
	end

end
