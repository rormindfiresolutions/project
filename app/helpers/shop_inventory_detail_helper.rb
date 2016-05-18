module ShopInventoryDetailHelper

	# For checking the unit type of shop product
	def check_unit_type(shop_product)
		shop_product.unit_type == 'packet' or shop_product.unit_type == 'pcs'
	end

end