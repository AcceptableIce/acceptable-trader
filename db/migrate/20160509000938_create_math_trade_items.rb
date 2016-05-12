class CreateMathTradeItems < ActiveRecord::Migration
  def change
    create_table :math_trade_items do |t|
	    t.integer :bgg_item, null: false, default: -1
	    t.references :user, index: true, null: false
	    t.references :math_trade, index: true, null: false
	    t.text :description
	    t.timestamps
    end
    
    add_foreign_key :math_trade_items, :users
    add_foreign_key :math_trade_items, :math_trades
  end
end
