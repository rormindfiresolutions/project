class AddressesController < ApplicationController
	before_action :authenticate_user!

	# To display all the Addresses
	def index
		@addresses = current_user.addresses
	end
	
	# To create a New Address
	def new
		@address = Address.new
		
		# For storing the previous page before current page
		session[:prev_url] = request.referer
	end

	def create
		@address = current_user.addresses.build(address_params)

		if @address.save
			flash[:success] = 'Address added'
			redirect_to session[:prev_url]
		else
			flash[:danger] = 'Not added'
			render 'new'
		end
	end

	# To Edit an Address
	def edit
		@address = current_user.addresses.find(params[:id])
	end

	def update
		@address = current_user.addresses.find(params[:id])
		if @address.update_attributes(address_params)
			flash[:success] = 'Updated Successfully'
			redirect_to addresses_path
		else
			flash[:danger] = 'Address not Updated'
			render 'edit'
		end
	end
	
	protected

		def address_params
			params.require(:address).permit(:address_type, :name, :address_1, :address_2, :city,
																			:state, :pincode, :landmark)
		end

end


