class UsersController < ApplicationController
  before_action :authenticate_user! , only: [:index, :show, :profile]
  skip_before_action :verify_authenticity_token, only: :search_shop

  # For Displaying Home Page
	def home
		render layout: false
	end

	# For Displaying About Page
	def about
	end

	# For Displaying Contact Page
	def contact
	end
	
	# For Listing all Customers for Admin's View
	def index
		authorize User
		respond_to do |format|
      format.html
      format.json {render json: UserDatatable.new(view_context)}
    end
	end
	
	# For Displaying User Information
	def show
		@user = User.find_by(id: params[:id])
	end

	# For Displaying User Information
	def profile
	end

	# For Searching a Shop Profile by Pincode
	def search_shop
		@search_address = Address.where(pincode_params)
		@shop_address = @search_address.where.not(shop_profile_id: nil)
		@shops_id = @shop_address.select('shop_profile_id')
		if !@shops_id.blank?
	 		@shops = Array.new
	 		@shops_id.each do |id|
				@shops.push ShopProfile.find_by(id: id.shop_profile_id) if 
				ShopProfile.find_by(id: id.shop_profile_id).is_approved
	 		end
	 	end
	 	if @shops.blank? or @shops_id.blank?
	 		flash[:danger] = 'Sorry! No Shops Available'
			redirect_to root_path
 		end
 	end

	private
		def pincode_params
			params.require(:address).permit(:pincode)
		end

end