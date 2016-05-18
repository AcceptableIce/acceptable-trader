class MathTradeWant < ActiveRecord::Base 
	belongs_to :math_trade
	belongs_to :user
	belongs_to :item, foreign_key: "math_trade_item_id", class_name: "MathTradeItem"
	belongs_to :bgg_item
	
	has_many :want_items, class_name: "MathTradeWantItem", :dependent => :destroy
end