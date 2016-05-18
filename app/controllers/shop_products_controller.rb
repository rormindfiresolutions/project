 class ShopProductsController < ApplicationController
	before_action :authenticate_user!, except: :show_image
	before_action :check_status, only: [:new, :create]

	def new
		@shop_product = ShopProduct.new
		@shop_profile = ShopProfile.find(params[:shop_profile_id])
		@categories = Category.all
		@brands = Brand.all
	end

	# For Adding a Product to Shop Inventory from Global Product Bank
	def create
		@shop = ShopProfile.find(params[:shop_profile_id])
		product = Product.find(params[:product_id])
		if current_user.shopkeeper? and product.is_active?
			shop_product = ShopProduct.new

			# Calling method add_product_to_shop_from_product_bank from Model
			ShopProduct.add_product_to_shop_from_product_bank(@shop, shop_product, product, flash)
			respond_to do |format|
      	format.html { redirect_to request.referer || root_path }
      	format.js {}
	    end
		else
			flash[:danger] = 'You cannot add Products'
			redirect_to root_path
		end
	end

	def edit
		@shop = ShopProfile.find(params[:shop_profile_id])
		@shop_product = ShopProduct.find(params[:id])
	end

	# For Updating a Shop Product with MRP, Selling Price and Product Description
	def update
		@shop = ShopProfile.find(params[:shop_profile_id])
		@shop_product = ShopProduct.find(params[:id])
		if @shop_product.update_attributes(shop_product_params)
			flash[:success] = 'You updated a Product in your Shop'
			redirect_to new_shop_inventory_detail_path(shop_product_id: @shop_product.id)
		else
			render 'edit'
		end
	end

	# for Showing Image for a Shop Product of a Shop Profile
  def show_image
		@shop_product = ShopProduct.find(params[:id])
		if @shop_product.image.nil?
			send_data open("#{Rails.root}/lib/seeds/images/no_image.jpg", "rb").read, type: 'image/jpg'
		else
			send_data @shop_product.image, type: 'image/jpg'
		end
	end

	# For Adding a Shop Product to Shop Profile manually for selling locally 
	def add_product_manually
		@shop = ShopProfile.find_by(id: params[:shop_profile_id])
		@shop_product = ShopProduct.new(shop_product_params)
		@shop_product.brand_name = Brand.find_by(id: params[:product][:brand_id]).brand_name if @shop_product.brand_name == ''
		@inventory = @shop_product.build_shop_inventory(shop_inventory_params)

		if @inventory.quantity.present?
			if (@shop_product.unit_type == 'packet' or @shop_product.unit_type == 'pcs') and @inventory.quantity % 1 != 0
				flash[:danger] = 'Please enter whole numbers for packed products'
				redirect_to request.referer and return
			end
		end

		# Calling method build_shop_inventory_details from Model
		ShopProduct.build_shop_inventory_details(@shop, @shop_product, @inventory)

		# Calling method identical from Model
		if ShopProduct.identical(@shop_product) 
			flash[:danger] = 'Product already exists'
			redirect_to request.referer
		elsif @shop_product.save
			flash[:success] = 'You added a Product to your Shop'
			redirect_to shop_profile_path(@shop_product.shop_profile_id)
		else
			flash[:danger] = 'Error occured while adding Product. Please enter valid data'
			redirect_to request.referer
		end

	end

	def destroy
		@shop_product = ShopProduct.find(params[:id])
		if @shop_product.destroy
			UserBasket.where(shop_product_id: @shop_product.id).first.delete if 
			UserBasket.where(shop_product_id: @shop_product.id).present?
			flash[:success] = 'Product removed'
			respond_to do |format|
      	format.html { redirect_to request.referer || root_path }
      	format.js {}
	    end
		else
			flash[:danger] = "Error While Removing"
			redirect_to request.referrer || root_path
		end
	end

	private

	def shop_product_params
		params.require(:shop_product).permit(:product_name, :product_description, :unit_type, :category_name,
		 																:brand_name, :selling_price, :mrp, :category_id, :brand_id, 
		 																:product_id, :image)
	end

	def shop_inventory_params
		params.require(:shop_inventory).permit(:quantity)
	end
	
	# For Checking whether a Shop Profile is Approved by Admin or not to add Shop Products to Shop Profile
  def check_status
		@shop = ShopProfile.find_by(id: params[:shop_profile_id])
		if @shop.is_approved == false
			flash[:danger] = 'You are not approved to add products'
			redirect_to root_path
		end
	end

end
