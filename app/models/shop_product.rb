class ShopProduct < ActiveRecord::Base
	acts_as_paranoid

	has_one :shop_inventory
	has_many :shop_inventory_details
	belongs_to :shop_profile
	belongs_to :product
	belongs_to :category
	belongs_to :user_basket

	validates :unit_type, inclusion: { in: %w(packet pcs kgs gms ltr ml) }
	VALID_LETTER_DIGIT_REGEX = /\A[0-9a-zA-Z_ _'&]+\z/
	validates :product_name, format: { with: VALID_LETTER_DIGIT_REGEX }, length: { minimum: 3, maximum: 30 }
	VALID_NAME_REGEX = /\A[a-zA-Z_ _']+\z/
  validates :brand_name, format: { with: VALID_NAME_REGEX }, length: { minimum: 3, maximum: 30 }
  validates :product_description, format: { with: VALID_NAME_REGEX }, allow_blank: true
  validates :selling_price, numericality: { greater_than_or_equal_to: 0 }
	validates :mrp, numericality: { greater_than_or_equal_to: 0 }

	accepts_nested_attributes_for :shop_inventory

	private

		# For Searching Shop Products by Product Name or Brand Name
		def self.search(search)
		  if search
		    where("product_name like ? or brand_name like ?", "%#{search}%", "%#{search}%")
		  else
		    all
		  end
		end	

		# For Adding a Shop Product to Shop Profile from Global Product Bank
		def self.add_product_to_shop_from_product_bank(shop, shop_product, product, flash)
			if shop.shop_products.find_by_product_id(product.id)
				flash[:danger] = 'Product Already Exists'
			else
				shop_product.product_name = product.product_name
				shop_product.image = product.image
				shop_product.unit_type = product.unit_type
				shop_product.product_description = product.product_description
				shop_product.category_id = product.category_id
				shop_product.product_id = product.id
				shop_product.brand_name = product.brand.brand_name
				shop_product.create_shop_inventory
				shop.shop_products << shop_product
				shop.save
				flash[:success] = 'You added a Product to your Shop'
			end
		end

		# To check whether a product added locally already exists in shop or not
	  def self.identical other 
	  	ShopProduct.exists?(product_name: other.product_name, brand_name: other.brand_name,
	  	 category_id: other.category_id, shop_profile_id: other.shop_profile_id)
	  end

	  # To build shop inventory details of a product added locally
	  def self.build_shop_inventory_details(shop, shop_product, inventory)
			inventory_detail = shop_product.shop_inventory_details.build
			inventory_detail.inventory_type = 'Initialization'
			inventory_detail.quantity = inventory.quantity
			inventory_detail.shop_profile_id = shop.id
			shop_product.shop_profile_id = shop.id
	  end

end

