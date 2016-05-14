class MathTradeWantsController < ApplicationController
	before_filter :load_trade, :validate_is_before_wants_deadline
	def create
		params[:math_trade_want][:math_trade_id] = @trade.id
		params[:math_trade_want][:user_id] = current_user.id
		@want = MathTradeWant.find_or_create_by(want_params)
		if @want.save
			if !params[:allowed_items].nil?
				want_items_found = []
				params[:allowed_items].each do |item|
					want_item_params = {
						math_trade_want_id: @want.id,
						math_trade_item_id: item.to_i
					}
					@want.want_items.find_or_create_by(want_item_params)
					want_items_found.push(item.to_i)
				end
				@want.want_items(current_user).where.not({ math_trade_item_id: want_items_found }).destroy_all
			end
			render json: { error: false, message: "Saved successfully." }
		else
			render json: { error: true, message: "Unable to save want request." }
		end
	end
		
	def want_params
		params.require(:math_trade_want).permit(:user_id, :math_trade_id, :math_trade_item_id)
	end
	
	def load_trade
		@trade = MathTrade.find(params[:math_trade_id])
	end
		
	def validate_is_before_wants_deadline
		if @trade.wants_due?
			render json: { error: true, message: "Wants deadline has passed." }
		end
	end
	
end
