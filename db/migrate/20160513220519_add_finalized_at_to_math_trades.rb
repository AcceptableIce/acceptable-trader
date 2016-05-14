class AddFinalizedAtToMathTrades < ActiveRecord::Migration
  def change
    add_column :math_trades, :finalized_at, :datetime, null: true
  end
end
