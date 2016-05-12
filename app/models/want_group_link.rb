class WantGroupLink < ActiveRecord::Base
	belongs_to :want_group
	belongs_to :math_trade_want
end