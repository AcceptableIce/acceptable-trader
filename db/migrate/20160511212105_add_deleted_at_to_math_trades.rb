class AddDeletedAtToMathTrades < ActiveRecord::Migration
  def change
    add_column :math_trades, :deleted_at, :datetime
    add_index :math_trades, :deleted_at
  end
end
