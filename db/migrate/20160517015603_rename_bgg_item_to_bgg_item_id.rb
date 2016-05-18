class RenameBggItemToBggItemId < ActiveRecord::Migration
  def change
	  rename_column :math_trade_items, :bgg_item, :bgg_item_id
  end
end
