class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :check_validation
 
  def welcome  
	end
	
	protected 
	
	def add_callout(type, message)
		if @callouts.nil?
			@callouts = []
		end
		
		@callouts.push({ type: type, message: message })
	end
		
	def check_validation
		if !current_user.nil? && current_user.bgg_user.nil?
			add_callout("warning", "You have not yet linked your BGG account to your Math Trade Manager account. " + 
				"Until you do so, you won't be able to enter any trades.")
		end
	end
	
end
