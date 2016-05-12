class CreateWantGroupLinks < ActiveRecord::Migration
  def change
    create_table :want_group_links do |t|
	    t.references :want_group, index: true, null: false
	    t.references :math_trade_want, index: true, null: false
	    t.timestamps null: false
    end
    
    add_foreign_key :want_group_links, :want_groups
    add_foreign_key :want_group_links, :math_trade_wants
  end
end
