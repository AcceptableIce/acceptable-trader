class AddDidTradeToMathTradeItems < ActiveRecord::Migration
  def change
    add_column :math_trade_items, :did_trade, :boolean, after: :alt_name, default: false
  end
end
