class ShopInventoryDetail < ActiveRecord::Base
	belongs_to :shop_inventory
	belongs_to :shop_product
	belongs_to :shop_profile

	validates :quantity, numericality: { greater_than_or_equal_to: 0 }

	private

		# For Building Shop Inventory and Shop Inventory Details if they don't Exist
		def self.build_shop_inventory_and_shop_inventory_details(shop_product)
			if shop_product.shop_inventory_details.nil?
				shop_product.shop_inventory_detail.build
			end			 

			if shop_product.shop_inventory.nil?
				shop_product.build_shop_inventory
			end
		end

		# For Updating the Shop Inventory Detail as per Inventory Type
		def self.change_quantity_as_per_inventory_type(shop_product, params)
			if params[:shop_inventory_detail][:inventory_type] == 'Sale'
				shop_product.shop_inventory.quantity -= params[:shop_inventory_detail][:quantity].to_f
			elsif params[:shop_inventory_detail][:inventory_type] == 'Purchase'
				shop_product.shop_inventory.quantity += params[:shop_inventory_detail][:quantity].to_f
			elsif params[:shop_inventory_detail][:inventory_type] == 'Initialization'
				shop_product.shop_inventory.quantity = params[:shop_inventory_detail][:quantity].to_f
			elsif params[:shop_inventory_detail][:inventory_type] == 'Adjustment'
				shop_product.shop_inventory.quantity -= params[:shop_inventory_detail][:quantity].to_f				
			end
		end

		# For Saving Shop Inventory as per Quantity
		def self.save_shop_inventory(shop_product, flash ,shop_inventory_detail)
			if shop_product.shop_inventory.quantity < 0
				flash[:danger] = 'Insufficient Quantity'
			elsif shop_product.shop_inventory.save
		  	flash[:success] = 'Inventory details updated'
		  	shop_product.shop_inventory_details << shop_inventory_detail
			else
				flash[:danger] = 'Inventory details not added'			
			end		
		end

end
