class AddResultlistToMathTrades < ActiveRecord::Migration
  def change
    add_column :math_trades, :results_list, :binary, limit: 10.megabyte, after: :discussion_thread
  end
end
