class CreateMathTradeWants < ActiveRecord::Migration
  def change
    create_table :math_trade_wants do |t|
	    t.references :user, null: false, index: true
	    t.references :math_trade, null: false, index: true
	    t.references :math_trade_item, null: false, index: true
	    t.timestamps null: false
    end
    
    add_foreign_key :math_trade_wants, :users
    add_foreign_key :math_trade_wants, :math_trades
    add_foreign_key :math_trade_wants, :math_trade_items
  end
end
