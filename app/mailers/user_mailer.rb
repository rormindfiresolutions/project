class UserMailer < Devise::Mailer   
  helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`
  # default template_path: 'devise/mailer' # to make sure that your mailer uses the devise views
  default from: 'kiranastore@gmail.com'
 
  def confirmation_instructions(record, token, opts={})
    if !record.guest?
      super
    end
  end

  def reset_password_instructions(record, token, opts={})
    if !record.guest?
     super
    end
  end

  def unlock_instructions(record, token, opts={})
    if !record.guest?
      super
    end
  end

  def password_change(id)
    record = User.find(id)
    devise_mail(record, :password_change)
  end

  def order_information(user, order_lines)
    @order_lines = order_lines
    @user = user
    mail(to: @user.email, subject: 'Order Sucessfully Placed')
  end

  def order_cancellation(user , order)
    @user = user
    @order = order
    mail(to: @user.email, subject: 'Order is cancelled')
  end

end
