class UserProfilesController < ApplicationController
	before_action :authenticate_user!
	
	def new
		@detail = UserProfile.new

		# For storing the previous page before current page
		if URI(request.referer).path != '/users/sign_in'
			session[:prev_url] = request.referer 
		else
			session[:prev_url] = root_path
		end
	end

	# For creating a User Profile for both Customer and Shopkeeper
	def create
		@detail = current_user.build_user_profile(user_params)
		if @detail.save
			flash[:success] = 'User details added'
			redirect_to session[:prev_url]
		else
			render 'new'
		end
	end

	private
		def user_params
			params.require(:user_profile).permit(:first_name, :last_name, :phone_number, :email)
		end

end