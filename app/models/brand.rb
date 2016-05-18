class Brand < ActiveRecord::Base
	has_many :products

	VALID_NAME_REGEX = /\A[a-zA-Z_ _'&]+\z/
	validates :brand_name, format: { with: VALID_NAME_REGEX }, length: { minimum: 3, maximum: 30 }
	
end
