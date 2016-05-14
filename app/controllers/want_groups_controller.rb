class WantGroupsController < ApplicationController
	before_filter :load_trade, :validate_is_before_wants_deadline
	
	def create
		params[:want_group][:math_trade_id] = @trade.id
		params[:want_group][:user_id] = current_user.id
		@group = WantGroup.new(want_group_params)
		if @group.save
			render json: { error: false, message: "Created successfully.", item: @group.as_json }
		else
			render json: { error: true, message: "Unable to create new group." }
		end
	end
	
	private
		
	def want_group_params
		params.require(:want_group).permit(:user_id, :math_trade_id, :name, :short_name)
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