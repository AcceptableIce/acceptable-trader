class CreateMathTradeWantItems < ActiveRecord::Migration
  def change
    create_table :math_trade_want_items do |t|
	    t.references :math_trade_want, index: true, null: false
	    t.references :math_trade_item, index: true, null: false
	    t.timestamps null: false
    end
    
    add_foreign_key :math_trade_want_items, :math_trade_wants
    add_foreign_key :math_trade_want_items, :math_trade_items
  end
end
