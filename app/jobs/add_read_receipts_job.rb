class AddReadReceiptsJob < ActiveJob::Base
  queue_as :default

  def perform(item_hashes, user)
	  item_ids = item_hashes.map { |x| x["id"].to_i }
	  items = MathTradeItem.where(id: item_ids)
    items.each do |item|
	    item.math_trade_read_receipts.find_or_create_by(user_id: user.id)
	   end
  end
end
