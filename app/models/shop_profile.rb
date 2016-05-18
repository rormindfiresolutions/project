class ShopProfile < ActiveRecord::Base
	has_one :address
	has_and_belongs_to_many :users
	has_one :shop_inventory_detail
	has_many :shop_products
	has_one :order_line
	has_many :orders
	has_many :shipping_charges

	VALID_SHOP_NAME_REGEX = /\A[a-zA-Z0-9_ ._']+\z/
	validates :shop_name, length: { minimum: 3, maximum: 30 }, format: { with: VALID_SHOP_NAME_REGEX }
	VALID_PHONE_NUMBER_REGEX = /[789]\d{9}/
	validates :phone_number, format: { with: VALID_PHONE_NUMBER_REGEX }
	validates_format_of :email, allow_blank: true, with: Devise::email_regexp

	private

		def self.approve_shop(shop, flash)
			if ! shop.is_approved
	 	  	shop.is_approved = true
	 	  	shop.save 
	 	  	flash[:success] = 'Approved'
 	  	else
	 	  	shop.is_approved = false
	 	  	shop.save 
	 	  	flash[:danger] = 'Not Approved'	
 	  	end
		end

end