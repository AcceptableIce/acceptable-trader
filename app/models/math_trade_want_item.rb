class MathTradeWantItem < ActiveRecord::Base
	belongs_to :math_trade_want
	belongs_to :math_trade_item
end