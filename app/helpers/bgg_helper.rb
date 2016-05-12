module BggHelper
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
	
	def self.get_item(id)
		value = Rails.cache.fetch("bgg_item_#{id}/data");
		if value.nil?
			value = Rails.cache.fetch("bgg_item_#{id}/data", expires_in: 12.hours) do
				BoardGameGem.get_item(id, true)
			end
		end
		return value
	end
end
