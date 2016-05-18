class OrderLine < ActiveRecord::Base
	belongs_to :order
	belongs_to :shop_product

	private

		# To auto manage Shop inventory Detail if an Order is placed successfully
		def self.add_order_to_inventory_details(shop_product, product, user)
			shop_inventory_detail = ShopInventoryDetail.new
			if shop_product.shop_inventory.nil?
				shop_product.build_shop_inventory
			end
			shop_product.shop_inventory.quantity -= product.quantity
			shop_inventory_detail.quantity = product.quantity
			shop_inventory_detail.inventory_type = 'Sale'
			shop_inventory_detail.notes = 'Sold to' + ' ' + user.email 
			shop_inventory_detail.shop_product_id = shop_product.id
			shop_inventory_detail.shop_profile_id = shop_product.shop_profile_id
			shop_product.shop_inventory.shop_inventory_details <<  shop_inventory_detail
			shop_product.shop_inventory.save
		end
		
end
