class UserProfile < ActiveRecord::Base
	belongs_to :user

	nilify_blanks only: [:first_name, :last_name, :phone_number, :email]

	VALID_NAME_REGEX = /\A[a-zA-Z]+\z/
  VALID_PHONE_NUMBER_REGEX = /[789]\d{9}/

	with_options if: :is_customer? do |customer|
    customer.validates :first_name, length: { minimum: 3, maximum: 30 }, 
    format: { with: VALID_NAME_REGEX }
    customer.validates :last_name, length: { minimum: 3, maximum: 30 },
    format: { with: VALID_NAME_REGEX }, allow_blank: true
    customer.validates :phone_number, format: { with: VALID_PHONE_NUMBER_REGEX }, allow_blank: true
    customer.validates_format_of :email, with: Devise::email_regexp, allow_blank: true
  end

  def is_customer?
    user.customer?
  end

  with_options if: :is_shopkeeper? do |shopkeeper|
    shopkeeper.validates :first_name, length: { minimum: 3, maximum: 30 }, 
    format: { with: VALID_NAME_REGEX }
    shopkeeper.validates :last_name, length: { minimum: 3, maximum: 30 }, 
    format: { with: VALID_NAME_REGEX }
    shopkeeper.validates :phone_number, format: { with: VALID_PHONE_NUMBER_REGEX }
    shopkeeper.validates_format_of :email, with: Devise::email_regexp
  end

  def is_shopkeeper?
  	user.shopkeeper?
  end
  
end
