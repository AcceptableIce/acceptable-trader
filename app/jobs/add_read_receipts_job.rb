class AddReadReceiptsJob < ActiveJob::Base
  queue_as :default

  def perform(item_hashes, user)
	  item_ids = item_hashes.map { |x| x["id"].to_i }
	  items = MathTradeItem.includes(:math_trade_read_receipts).where(id: item_ids)
    items.each do |item|
	    if !item.math_trade_read_receipts.any? { |x| x.user_id == user.id }
		    item.math_trade_read_receipts.create(user_id: user.id)
		  end
	   end
  end
end
