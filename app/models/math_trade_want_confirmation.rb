class MathTradeWantConfirmation < ActiveRecord::Base
	belongs_to :user
	belongs_to :math_trade
end