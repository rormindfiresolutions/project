class ShopInventoryDetailsController < ApplicationController
	before_action :authenticate_user!

	def new
		authorize ShopInventoryDetail
   	@shop_product = ShopProduct.find(params[:shop_product_id])
		@shop_inventory_detail = ShopInventoryDetail.new
	end

	# For Creating Shop Inventory Detail of a Shop Product
	def create
		authorize ShopInventoryDetail
		@shop_product = ShopProduct.find_by(id: params[:shop_product_id])
		@shop_inventory_detail = ShopInventoryDetail.new(shop_inventory_detail_params)

		# Calling Method build_shop_inventory_and_shop_inventory_details from Model
		ShopInventoryDetail.build_shop_inventory_and_shop_inventory_details(@shop_product)

		@shop_inventory_detail.shop_inventory_id = @shop_product.shop_inventory.id
		@shop_inventory_detail.shop_profile_id = @shop_product.shop_profile.id
		
		# Calling Method change_quantity_as_per_inventory_type from Model
		ShopInventoryDetail.change_quantity_as_per_inventory_type(@shop_product, params)

		if (@shop_product.unit_type == 'packet' or @shop_product.unit_type == 'pcs') and 
			@shop_inventory_detail.quantity % 1 != 0
			flash[:danger] = 'Please enter whole numbers for packed products'
			redirect_to new_shop_inventory_detail_path(shop_product_id: @shop_product.id) and return
		end

		# Calling Method save_shop_inventory from Model
		ShopInventoryDetail.save_shop_inventory(@shop_product, flash ,@shop_inventory_detail)
		redirect_to shop_profile_path(@shop_product.shop_profile_id)
	end

	# For Displaying Shop Inventory Details of a Shop Product 
	def index
		authorize ShopInventoryDetail
  	@shop_product = ShopProduct.unscoped.find(params[:shop_product_id])
		@shop_inventory_details = @shop_product.shop_inventory_details
	end


	protected

		def shop_inventory_detail_params
			params.require(:shop_inventory_detail).permit(:inventory_type, :quantity, :notes, :shop_profile_id)
		end

end



