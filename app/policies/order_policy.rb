class OrderPolicy
  attr_reader :current_user, :model

  def initialize(current_user, model)
    @current_user = current_user
    @model = model
  end

  def edit?
    current_user.shop_profiles.exists?(model.shop_profile_id)
  end

  def update?
    current_user.shop_profiles.exists?(model.shop_profile_id)
  end

  def show?
    current_user.shop_profiles.exists?(model.shop_profile_id) || current_user.orders.exists?(model.id)
  end

  def index?
    model.each do |order|
      if !(current_user.shop_profiles.exists?(order.shop_profile_id) || current_user.orders.exists?(order.id))
        false
        break
      end
    end
  end

  def revert_order_state?
    current_user.shop_profiles.exists?(model.shop_profile_id)
  end

end



