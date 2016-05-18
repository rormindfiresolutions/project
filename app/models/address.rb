class Address < ActiveRecord::Base
	belongs_to :user
	belongs_to :shop_profile
	has_many :orders

	nilify_blanks only: [:name, :landmark, :address_type]

	VALID_ADDRESS_REGEX = /\A[a-zA-Z0-9_ ,-\/]+\z/
	validates :address_1, length: { minimum: 3, maximum: 100}, format: { with: VALID_ADDRESS_REGEX }, presence: true
	VALID_PLACE_REGEX = /[a-zA-Z_ ]/
	validates :city, length: { minimum: 3, maximum: 30 }, format: { with: VALID_PLACE_REGEX }, presence: true
	validates :state, length: { minimum: 3, maximum: 30 }, format: { with: VALID_PLACE_REGEX }, presence: true
	VALID_NAME_REGEX = /\A[a-zA-Z. ]+\z/
	validates :name, length: { maximum: 30 }, format: { with: VALID_NAME_REGEX }, allow_blank: true
	validates :pincode, length: { is: 6}, numericality: { only_integer: true }, presence: true
end
