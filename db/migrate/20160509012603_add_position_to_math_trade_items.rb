class AddPositionToMathTradeItems < ActiveRecord::Migration
  def change
    add_column :math_trade_items, :position, :integer
  end
end
