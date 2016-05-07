require 'bgg'

class WelcomeController < ApplicationController
	
	def index
		@user = BGGUser.find("AcceptableIce")
		if !@user.nil?
			
		else
			p "User not found"
		end#MailHelper.send_bgg_mail("AcceptableIce", "Test Mail", "This is a test!")
	end
end
