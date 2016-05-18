class ApplicationController < ActionController::Base

  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  helper_method :current_user

  # For rasing no routes match when record not found
  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  # For displaying User Details Form after first Sign in  
  def after_sign_in_path_for(user)
    if user.sign_in_count == 1 and current_user.customer?
      new_user_profile_path
    elsif current_user.shopkeeper? and user.user_profile.nil?
      new_user_profile_path
    else
      root_path
    end
  end

  # For deciding current_user 
  def current_user
    super or guest_user
  end

  private

    # For finding a Guest User
    def guest_user
      User.find(session[:guest_user_id].nil? ? session[:guest_user_id] = create_guest_user.id : session[:guest_user_id])
    end

    # For creating a Guest User
    def create_guest_user
      user = User.new { |user| user.role = 'guest' }
      user.email = "guest_#{Time.now.to_i}#{rand(99)}@example.com"
      user.save(validate: false)
      user
    end

    # For denying a User to access a page which they are not authorised to (Pundit)
    def user_not_authorized
      flash[:danger] = "Access denied."
      redirect_to (request.referrer || root_path)
    end

    # If a Record is not found which is searched (Exception Handler)
    def record_not_found
      flash[:danger] = 'Record Not Found'
      redirect_to (request.referrer || root_path)
    end

    # If no Routes are found 
    def no_routes_found
      flash[:danger] = 'Invalid Route'
      redirect_to root_path
    end

    # To add custom fields to strong parameters
    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:password, :role, :email) }
      devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:email, :password, :password_confirmation,
                                                       :current_password, :first_name, :last_name, :phone_number) } 
    end
end


