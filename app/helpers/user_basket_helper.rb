module UserBasketHelper

	# Returns shipping_cost acoording to the range in which sum lies
	def shipping_charge shop,cost 
		shop_profile = ShopProfile.find(shop.shop_profile_id)
		shop_profile.shipping_charges.where("minimum_order_cost <= ? and maximum_order_cost >= ?",cost,cost).first.shipping_cost
	end

	# Returns false if a shipping_charge exists for the given sum
	def find_shipping_charge shop,cost 
		shop_profile = ShopProfile.find(shop.shop_profile_id)
		temp = true
		shop_profile.shipping_charges.each do |f|
		  if cost.between?(f.minimum_order_cost, f.maximum_order_cost)
		  	temp = false
	 		end
		end
		return temp
	end

	# Finds the shop_name of the shop passed
	def shop_name shop
		ShopProfile.where(id: shop.shop_profile_id).first.shop_name
	end

	# Finds the product_name of the item passed
	def item_detail item
		ShopProduct.unscoped.where(id: item.shop_product_id).first.product_name
	end

	# Finds the selling_price of the item passed
	def selling_price item
		ShopProduct.unscoped.where(id: item.shop_product_id).first.selling_price
	end

	# Calculates the total amount of all the products added to cart
	def total_cost(shop)
		sum = 0;
		user_basket = @user_baskets.where(shop_profile_id: shop.shop_profile_id)
		user_basket.each do |item|
			sum += item.quantity * selling_price(item)
		end
		return sum
	end

	# For checking the unit type of shop product
	def check_unit_type(shop_product)
		shop_product.unit_type == 'packet' or shop_product.unit_type == 'pcs'
	end
	
end
