class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  has_one :user_profile ,dependent: :destroy
  has_many :addresses
  has_and_belongs_to_many :shop_profiles
  has_one :user_log
  has_many :user_baskets
  has_many :orders

  validates :role, inclusion: { in: %w(customer shopkeeper) }

  accepts_nested_attributes_for :user_profile
  accepts_nested_attributes_for :shop_profiles

  enum role: [:customer, :shopkeeper, :admin, :guest]
  after_initialize :set_default_role, if: :new_record?

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :lockable

  after_update :send_password_change_email, if: :needs_password_change_email?
  
  def move_to(user)
    user_baskets.update_all(user_id: user.id)
  end

  private

    def set_default_role
      self.role ||= :customer
    end

    def needs_password_change_email?
      encrypted_password_changed? && persisted?
    end

    def send_password_change_email
      UserMailer.password_change(id).deliver
    end
end 



