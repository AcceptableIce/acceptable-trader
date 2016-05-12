class CreateWantGroupItems < ActiveRecord::Migration
  def change
    create_table :want_group_items do |t|
			t.references :want_group, index: true, null: false
	    t.references :math_trade_item, index: true, null: false
	    t.timestamps null: false
    end
    
    add_foreign_key :want_group_items, :want_groups
    add_foreign_key :want_group_items, :math_trade_items
  end
end
