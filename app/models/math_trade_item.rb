include BggHelper
include BoardGameGem

class MathTradeItem < ActiveRecord::Base
	belongs_to :user
	belongs_to :math_trade
	acts_as_list scope: :math_trade
	acts_as_paranoid
	
	has_many :wants, class_name: "MathTradeWant"
		
	has_many :wanted_by_items, through: :wants, source: :want_items
	
	has_many :math_trade_read_receipts
	
	validate :name_is_set, :check_linked_items
	
	belongs_to :bgg_item, class_name: "BggItemData"
	
	def to_bgg_item
		if bgg_item != -1
			return BggHelper.get_item(bgg_item)
		else
			return BGGItem.new(nil)
		end
	end
	
	def is_bgg_item_loaded?
		if bgg_item != -1
			return !bgg_item.nil? && (DateTime.now - bgg_item.created_at.to_date).to_i < 14
		else
			true
		end
	end
	
	def wanted_by
		return math_trade.wants.select {|x| x.math_trade_item_id == id }
	end
	
	def get_linked_items
		linked_items = {}
		description.gsub(/\[item(=(.*?))?\]/) do |match|
			item_code = Regexp.last_match[2]
			item_data = BggHelper.get_item(item_code)
			linked_items[item_code] = item_data;
		end
		return linked_items
	end
	private
	
	def name_is_set
		if bgg_item == -1 && (alt_name.nil? || alt_name.length == 0)
			errors.add(:alt_name, "must be set if a BGG item is not selected.")
		end
	end
	
	def check_linked_items
		failed_items = get_linked_items.select { |key, value| value == nil }
		if failed_items.length > 0
			errors.add(:base, "One or more of your linked items (" + failed_items.keys.to_sentence + ") could not be found.")
		end
	end
end