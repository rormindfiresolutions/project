class ShippingChargePolicy
	attr_reader :current_user, :model

  def initialize(current_user, model)
    @current_user = current_user
    @model = model
  end

  def create?
    current_user.shop_profiles.exists?(model.shop_profile_id)
  end

  def edit?
    current_user.shop_profiles.exists?(model.shop_profile_id)
  end

  def update?
    current_user.shop_profiles.exists?(model.shop_profile_id)
  end

  def destroy?
    current_user.shop_profiles.exists?(model.shop_profile_id)
  end
end