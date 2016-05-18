class BggItemData < ActiveRecord::Base
	has_many :bgg_item_data_ranks, :dependent => :destroy
end