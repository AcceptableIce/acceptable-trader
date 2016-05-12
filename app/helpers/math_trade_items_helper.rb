module MathTradeItemsHelper
	def get_trade
		return MathTrade.find(params[:math_trade_id])
	end
end
