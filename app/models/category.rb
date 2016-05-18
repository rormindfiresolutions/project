class Category < ActiveRecord::Base
	has_many :products

	VALID_NAME_REGEX = /\A[a-zA-Z_ &]+\z/
	validates :category_name, format: { with: VALID_NAME_REGEX }, length: { minimum: 3, maximum: 30 }

end
