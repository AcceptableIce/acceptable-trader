module BggImporterService
	@@items_queue = []
	
	def self.enqueue_items(ids)
		@@items_queue += (ids - @@items_queue)
	end
	
	def self.start
		scheduler = Rufus::Scheduler.new

		scheduler.every "5s" do
			Rails.logger.debug("#{@@items_queue.length} game data items in queue.")
			if @@items_queue.length > 0
				items_to_fetch = @@items_queue.shift(25)
				items = BggHelper.fetch_items(items_to_fetch)
				items_ids = items.map { |x| x.id }
				items_missing = items_to_fetch - items_ids
				if items_missing.length > 0
					enqueue_items(items_missing)
				end
			end
		end
	end
end