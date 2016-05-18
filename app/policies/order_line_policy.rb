class OrderLinePolicy
	attr_reader :current_user, :model

  def initialize(current_user, model)
    @current_user = current_user
    @model = model
  end

  def new?
    current_user.customer? or current_user.shopkeeper?
  end

  def create?
  	current_user.customer? or current_user.shopkeeper?
  end

end

