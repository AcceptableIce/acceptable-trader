class WantGroupItem < ActiveRecord::Base
	belongs_to :want_group
	belongs_to :math_trade_item
end