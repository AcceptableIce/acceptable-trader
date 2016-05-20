class MathTradeReadReceipt < ActiveRecord::Base
	belongs_to :math_trade_item
	belongs_to :user
end