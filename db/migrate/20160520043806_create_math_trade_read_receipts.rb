class CreateMathTradeReadReceipts < ActiveRecord::Migration
  def change
    create_table :math_trade_read_receipts do |t|
	    t.references :math_trade_item, index: true, null: false
	    t.references :user, index: true, null: false
	    t.timestamps null: false
    end
    
    add_foreign_key :math_trade_read_receipts, :math_trade_items
    add_foreign_key :math_trade_read_receipts, :users
  end
end
