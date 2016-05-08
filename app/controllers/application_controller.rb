class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :check_validation
 
  def welcome  
	end
	
	protected 
	
	def show_error(message)
    redirect_to root_url, flash: { "callouts": [{ type: "alert", message: message }]}
	end
	
	def add_callout(type, message)
		@callouts.push({ type: type, message: message })
	end
		
	def check_validation
		if @callouts.nil?
			@callouts = []
			if !flash[:callouts].nil?
				flash[:callouts].each do |callout|
					add_callout(callout["type"], callout["message"])
				end
			end
		end	
		if !current_user.nil? && current_user.bgg_user.nil?
			add_callout("warning", "You have not yet linked your BGG account to your Math Trade Manager account. " + 
				"Until you do so, you won't be able to enter any trades.")
		end
	end
	
end
