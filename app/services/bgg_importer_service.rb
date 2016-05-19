module BggImporterService
	@@items_queue = []
	def self.enqueue_items(ids)
		@@items_queue += (ids - @@items_queue)
	end
	
	def self.start
		Rails.logger.debug "Starting BGG Importer service."
		scheduler = Rufus::Scheduler.new

		scheduler.every "5s" do
			#Fetch items that have not been found
			ids = ActiveRecord::Base.connection.select_all("SELECT math_trade_items.bgg_item_id FROM math_trade_items WHERE math_trade_items.bgg_item_id NOT IN " +
			 "(SELECT DISTINCT bgg_item_data.id FROM math_trade_items INNER JOIN bgg_item_data ON bgg_item_data.id = math_trade_items.bgg_item_id)")
			 .map{ |x| x["bgg_item_id"].to_i }
			self.enqueue_items(ids)
			
			missing_users = User.where(bgg_user_data_id: nil)
			
			Rails.logger.debug("#{@@items_queue.length} game records, #{missing_users.length} user records unimported.")
			if @@items_queue.length > 0
				items_to_fetch = @@items_queue.shift(25)
				items = BggHelper.fetch_items(items_to_fetch)
				items_ids = items.map { |x| x.id }
				items_missing = items_to_fetch - items_ids
				if items_missing.length > 0
					enqueue_items(items_missing)
				end
			end
			
			missing_users.each do |missing_user|
				bgg_user = BggHelper.get_user(missing_user.bgg_account)
				missing_user.bgg_user_data_id = bgg_user.id
				missing_user.save
			end
		end
	end
end