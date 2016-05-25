class BggController < ApplicationController
  def verify_user_account
		key = params[:key]
		if user_signed_in?
			if key == current_user.bgg_account_verification_code
				current_user.bgg_account_verified = true
				current_user.save
				redirect_to root_path
				flash[:notice] = "Verification successful!"
			else
				show_error "Verification code did not match our records."
			end 
		else
			redirect_to user_session_path
		end
	end
	
	def send_validation
		if user_signed_in? && !current_user.verified?
			current_user.send_verification_message
			flash[:notice] = "GeekMail sent!"
		end
		
		redirect_to root_path
	end
	
	def search_items
		query = params[:query]
		items = Rails.cache.fetch("search/#{query}", expires_in: 10.minutes) do
			BoardGameGem.search(query)
		end
		render json: items
	end

end
