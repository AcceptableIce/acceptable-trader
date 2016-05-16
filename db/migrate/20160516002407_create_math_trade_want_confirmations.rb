class CreateMathTradeWantConfirmations < ActiveRecord::Migration
  def change
    create_table :math_trade_want_confirmations do |t|
	    t.references :math_trade, index: true, null: false
	    t.references :user, index: true, null: false
	    t.timestamps null: false
    end
    
    add_foreign_key :math_trade_want_confirmations, :math_trades
    add_foreign_key :math_trade_want_confirmations, :users
  end
end
