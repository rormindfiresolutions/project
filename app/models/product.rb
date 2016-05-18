class Product < ActiveRecord::Base
	has_many :shop_products
	belongs_to :brand
	belongs_to :category

	VALID_LETTER_DIGIT_REGEX = /\A[0-9a-zA-Z_ _'&-]+\z/
	validates :product_name, format: { with: VALID_LETTER_DIGIT_REGEX }, length: { minimum: 3, maximum: 50 }
	VALID_NAME_REGEX = /\A[a-zA-Z_ ]+\z/
	validates :product_description, format: { with: VALID_NAME_REGEX }, allow_blank: true

	# For Searching Products by Product Name on Product Index Page
	def self.search(search)
	  if search
	    where("product_name like ?", "%#{search}%")
	  else
	    all
	  end
	end

	# To change the Activation status of a Product by Admin
	def self.activation_status(item, flash)
		if ! item.is_active
 	  	item.is_active = true
 	  	item.save 
 	  	flash[:success] = 'Activated'
 	  else
 	  	item.is_active = false
 	  	item.save 
 	  	flash[:warning] = 'Deactivated'
 	  end
 	end

end
