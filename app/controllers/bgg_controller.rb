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
				flash[:alert] = "Verification code did not match our records."
			end 
		else
			redirect_to login_path
		end
	end
end
