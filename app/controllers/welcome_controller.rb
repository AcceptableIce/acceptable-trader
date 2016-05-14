class WelcomeController < ApplicationController
	def index
		if current_user
			@trades = MathTrade.filter_by("participating", current_user)
		end
	end
	
	def rules
	end
	
	def about
	end
end
