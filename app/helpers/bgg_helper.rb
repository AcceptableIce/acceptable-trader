require "board-game-gem"
module BggHelper
	include BoardGameGem
	
	def self.send_mail_to_user(user, subject, message)
		username = Rails.application.config.bgg_mailer_username 
		password = Rails.application.config.bgg_mailer_password
			
		form_data = {
			action: "save",
			B1: "Send",
			savecopy: "0", 
			sizesel: "10", 
			folder: "inbox",
			ajax: "1",
			searchid: "0",
			pageID: "0",
			messageid: "",
			touser: user.name,
			subject: subject,
			body: message
		}
		
		headers = {
			Cookie: "bggusername=#{username}; bggpassword=#{password}"
		}
		
		uri = URI.parse("http://www.boardgamegeek.com/geekmail_controller.php")
		http = Net::HTTP.new(uri.host, uri.port)
		response, data = http.post(uri.path, form_data.to_query, headers)
		
		case response
		when Net::HTTPSuccess, Net::HTTPRedirection
			return true
		else
			return false
		end
	end	
	
	def generate_short_name(name, copy_index = 0)
		name = name.gsub(/[^0-9a-z ]/i, '')
		words = name.split
		if words.count > 4
			return words.map {|x| x[0]}.join.upcase + (copy_index > 0 ? "-COPY#{copy_index.to_s}" : "")
		else
			return name.gsub(" ", "")[0..4].upcase + (copy_index > 0 ? "-COPY#{copy_index.to_s}" : "")
		end
	end
	
	def self.fetch_items(ids)
		ids.select! {|x| x > 0 }
		#Rails.logger.debug "Fetching mass items from BGG: #{ids.join(",")}"
		added_items = []
		#Rails.logger.debug id_list.to_s
		items = BoardGameGem.get_items(ids.compact, true, 1, type: "boardgame,boardgameexpansion,videogame") rescue nil
		#Rails.logger.debug "Items found: #{items ? items.length : "nil"}"
		if !items.nil?
			items.each do |item|
				added_items.push(BggHelper.save_item(item))
			end
		end
		added_items
	end
	
	def self.get_item(id)
		BggItemData.find_by_id(id)
	end
	
	def self.save_item(item)
		if !item.nil?
			db_item = BggItemData.find_by_id(item.id)
			if db_item
				db_item.destroy
			end
			
			newItem = BggItemData.new
			newItem.id = item.id
			newItem.item_type = item.type
			newItem.image = item.image
			newItem.thumbnail = item.thumbnail
			newItem.name = item.name
			newItem.description = item.description
			newItem.year_published = item.year_published
			newItem.min_players = item.min_players
			newItem.max_players = item.max_players
			newItem.playing_time = item.playing_time
			newItem.min_playing_time = item.min_playing_time
			newItem.max_playing_time = item.max_playing_time
			if item.statistics
				newItem.user_ratings = item.statistics[:user_ratings]
				newItem.average = item.statistics[:average]
				newItem.bayes = item.statistics[:bayes]
				newItem.stddev = item.statistics[:stddev]
				newItem.median = item.statistics[:median]
				newItem.owned = item.statistics[:owned]
				newItem.trading = item.statistics[:trading]
				newItem.wanting = item.statistics[:wanting]
				newItem.wishing = item.statistics[:wishing]
				newItem.num_comments = item.statistics[:num_comments]
				newItem.num_weights = item.statistics[:num_weights]
				newItem.average_weight = item.statistics[:average_weight]
			end
			newItem.save
			if !item.statistics.nil?
				item.statistics[:ranks].each do |rank|
					newItem.bgg_item_data_ranks.create({
						rank_type: rank[:type],
						name: rank[:name],
						friendly_name: rank[:friendly_name],
						value: rank[:value],
						bayes: rank[:bayes]
					})
				end
			end
			item
		end
	end
	
	def self.get_user(username)
		user = BggUserData.where(name: username).first
		if user.nil? || (DateTime.now - user.created_at.to_date).to_i > 14
			user_data = BoardGameGem.get_user(username) rescue nil
			user = BggHelper.save_user(user_data)
			User.where(bgg_account: username).update_all(bgg_user_data_id: user.id)
		end
		user
	end
	
	def self.save_user(user)
		if !user.nil?
			db_item = BggUserData.find_by_id(user.id)
			if db_item
				db_item.destroy
			end
			
			newUser = BggUserData.new
			newUser.id = user.id
			newUser.name = user.name
			newUser.avatar = user.avatar
			newUser.year_registered = user.year_registered
			newUser.state = user.state
			newUser.trade_rating = user.trade_rating
			newUser.save
			newUser
		end
	end
end
