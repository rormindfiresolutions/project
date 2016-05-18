class ProductsController < ApplicationController
	before_action :authenticate_user!, except: :show_image

	def new
		authorize Product
		@product = Product.new
		@categories = Category.all
		@category = Category.new
		@brands = Brand.all
		@brand = Brand.new
	end

	# For creating a New Product which is done by Admin
	def create
	 	authorize Product
		@product = Product.new(product_params)
		@brand = Brand.new(brand_params)
		@category = Category.new(category_params)
		@product.category_id = params[:product][:category_id]
		if Brand.find_by(id: params[:product][:brand_id]).brand_name == 'Others'
			@product.build_brand(brand_params)
			@product.brand_id = @brand.id
		else
			@product.brand_id = params[:product][:brand_id]
		end
			
		@product.is_active = true
		if @product.save 
			flash[:success] = 'Successfully Added a new Product'
			redirect_to product_index_products_path
		else
			render 'new'
		end
	end

	# For displaying all the Products from Global Product Bank to Shopkeepers 
	def index
		@products = Product.all
		@shop_profile = ShopProfile.find_by(id: params[:shop_profile_id])
		@items = @products.where(is_active: true).paginate(page: params[:page], per_page: 6).search(params[:search])
		if !params[:category_id].nil?
			@items = @products.where(category_id: params[:category_id]).paginate(page: params[:page], per_page: 6)
		end	
		authorize @shop_profile
	end

	# For displaying all the Products from Global Product Bank to Admin in Datatable format 
	def product_index
		authorize Product
		respond_to do |format|
      format.html
      format.json {render json: ProductDatatable.new(view_context)}
    end
	end

 	# Changing status of a Product to Activated or Deactivated
 	def change_activation_status
 		authorize Product
 		@item = Product.find(params[:product_id])
 	  
 	  # Calling method activation_status from Model
 	  Product.activation_status(@item, flash)
 	  redirect_to request.referrer || root_path
 	end

 	# To show an Image for a Product
 	def show_image
		@product = Product.find(params[:id])
		if @product.image.nil?
			send_data open("#{Rails.root}/lib/seeds/images/no_image.jpg", "rb").read, type: 'image/jpg'
		else
			send_data @product.image, type: 'image/jpg'
		end
	end


	private

		def product_params
			params.require(:product).permit(:product_name, :product_description, :unit_type, :category_name,
			 																:brand_name, :is_active, :category_id, :image)
		end

		def brand_params
			params.require(:brand).permit(:brand_name)
		end

		def category_params
			params.require(:category).permit(:category_name)
		end
end


