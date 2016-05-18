module OrderHelper

	# The text to be displayed on button while changing order state 
	def state_text
		if @order.order_state == 'new'
		 'Process Order'
		elsif @order.order_state == 'in-progress'
			'Deliver'
		elsif @order.order_state == 'delivered'
			'Close Order'	
		end
	end

	# The text to be displayed on button while reverting order state 
	def revert_state_text
		if @order.order_state == 'delivered'
			'Revert to In-Progress'
		elsif @order.order_state == 'in-progress'
			'Revert to New'
		end
	end

	# To display the shipping charge as per the amount associated with an order
	def shipping_charge(order)
		shipping_charge = order.shop_profile.shipping_charges.where("minimum_order_cost <= ? and maximum_order_cost >= ?",
			order.order_value, order.order_value).first
		if shipping_charge
			shipping_charge.shipping_cost
		else 
			0
		end
	end
	
	# To display the count of new orders for a shop profile
	def new_order_count(shop_profile)
		shop_profile.orders.where("order_state='new'").count
	end

	# To display the count of orders in in-progress state for a shop profile
	def in_progress_order_count(shop_profile)
		shop_profile.orders.where("order_state='in-progress'").count
	end

	# To display the count of delivered orders for a shop profile
	def delevered_order_count(shop_profile)
		shop_profile.orders.where("order_state='delivered'").count 
	end

	# To display the count of closed orders for a shop profile
	def closed_order_count(shop_profile)
		shop_profile.orders.where("order_state='closed'").count
	end

	# To display the count of own orders(shopkeeper ordered some products)
	def shop_order_count(shop_profile)
		current_user.orders.count
	end

end