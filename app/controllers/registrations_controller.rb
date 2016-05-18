class RegistrationsController < Devise::RegistrationsController

	# For Creating a New User Account either as a Customer or Shopkeeper
	def create
    @user = User.new(user_params)
    if @user.save 
      flash[:success] = 'Confirm your mail'
      redirect_to root_path
    else
    	flash[:danger] = 'Invalid email or Password'
      render 'sessions/new'
    end
  end

  # For Creating a User Account either as of a Customer or Shopkeeper
	def update
		if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
	    params[:user].delete(:password)
	    params[:user].delete(:password_confirmation)
		end
		if current_user.user_profile.nil?
			current_user.build_user_profile(update_user_profile_params)
		end

		# Allowing Update with current_password only and keeping logged in after Update
		if current_user.update_with_password(update_user_params) and
			current_user.user_profile.update_attributes(update_user_profile_params)
				sign_in(current_user, bypass: true)
				flash[:success] = 'Account updated'
				redirect_to profile_users_path
		else 
			render 'edit'
		end
	end
	
	private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :role)
  end

  def update_user_params
  	params.require(:user).permit(:email, :current_password, :password, :password_confirmation)
  end

  def update_user_profile_params
  	params.require(:user_profile).permit(:first_name, :last_name, :phone_number, :email)
  end

end