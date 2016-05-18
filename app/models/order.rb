class Order < ActiveRecord::Base
	belongs_to :user
	belongs_to :address
	has_many :order_lines
	belongs_to :shop_profile
	validates :order_state, inclusion: { in: %w(new in-progress delivered closed) }

	private

		# To add the cancelled products back to Shop Inventory and Auto Update Shop Inventory Details
		def self.add_cancellation_to_inventory_details(shop_product, product)
			shop_inventory_detail = ShopInventoryDetail.new
			if shop_product.shop_inventory.nil?
				shop_product.build_shop_inventory
			end
			shop_product.shop_inventory.quantity += product.quantity
			shop_inventory_detail.quantity = product.quantity
			shop_inventory_detail.inventory_type = 'Adjust'
			shop_inventory_detail.notes = 'Cancelled'
			shop_inventory_detail.shop_product_id = shop_product.id
			shop_inventory_detail.shop_profile_id = shop_product.shop_profile_id
			shop_product.shop_inventory.shop_inventory_details <<  shop_inventory_detail
			shop_product.shop_inventory.save
		end

		# Method for Shopkeeper to change the state of an Order a step ahead 
		def self.changing_order_state(order)
			if order.order_state == 'new'
		 		order.order_state = 'in-progress'
			elsif order.order_state == 'in-progress'
				order.order_state = 'delivered'
			elsif order.order_state == 'delivered'
				order.order_state = 'closed'
			end		
		end

		# Method for Shopkeeper to change the state of an Order a step behind
		def self.reverting_order_state(order)
			if order.order_state == 'delivered'
		 		order.order_state = 'in-progress'
			elsif order.order_state == 'in-progress'
				order.order_state = 'new'
			end
		end 

		# Method for saving Order after Order State is reverted
		def self.order_save_after_revert(order, flash)	
			if order.save
				flash[:success] = 'Order State Reverted'
			else
				flash[:danger] = 'Error While Reverting State'
			end
		end

		# Method for saving Order after Order State is changed
		def self.order_save_after_change(order, flash)
			if order.save
				flash[:success] = 'Order State Changed'
			else
				flash[:danger] = 'Error While Changing State'
			end
		end

end
