include BggHelper
include "board-game-gem"

class MathTradeItem < ActiveRecord::Base
	belongs_to :user
	belongs_to :math_trade
	acts_as_list scope: :math_trade
	
	has_many :wants, class_name: "MathTradeWant"
		
	has_many :wanted_by_items, through: :wants, source: :want_items
	
	validate :name_is_set, :check_linked_items
	
	def to_bgg_item
		if bgg_item != -1
			return BggHelper.get_item(bgg_item)
		else
			return BGGItem.new(nil)
		end
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