require 'bgg'
require 'uri'
require 'net/http'

class BGGUser
	def initialize(data)
		@username = data["name"]
	end

	def send_mail(subject, message)
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
			touser: @username,
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
	
	def self.find(username)
		user = BggApi.user({ name: username })
		if user["id"].downcase != ""
			return BGGUser.new(user)
		else
			return nil
		end
	end
end
