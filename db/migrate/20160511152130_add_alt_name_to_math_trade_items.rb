class AddAltNameToMathTradeItems < ActiveRecord::Migration
  def change
	  add_column :math_trade_items, :alt_name, :string, after: :description
  end
end
