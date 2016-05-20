class AddDeletedAtToMathTradeItems < ActiveRecord::Migration
  def change
    add_column :math_trade_items, :deleted_at, :datetime, after: :updated_at
    add_index :math_trade_items, :deleted_at
  end
end
