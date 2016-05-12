class CreateWantGroups < ActiveRecord::Migration
  def change
    create_table :want_groups do |t|
	    t.references :user, index: true, null: false
	    t.references :math_trade, index: true, null: false
	    t.string :name, null: false
    end
    
    add_foreign_key :want_groups, :users
    add_foreign_key :want_groups, :math_trades
  end
end
