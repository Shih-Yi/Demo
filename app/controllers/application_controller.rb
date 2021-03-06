class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :first_name
    devise_parameter_sanitizer.for(:sign_up) << :last_name

    devise_parameter_sanitizer.for(:account_update) << :first_name
    devise_parameter_sanitizer.for(:account_update) << :last_name
  end

  protected

  helper_method :current_cart

  def current_cart
    if @cart
      return @cart

    else
      if cookies.signed[:cart_id]
        @cart = Cart.find( cookies.signed[:cart_id] )
      else
        @cart = Cart.create
        cookies.permanent.signed[:cart_id] = @cart.id
      end
      return @cart
    end
  end

  def check_admin
    unless current_user.admin?
      flash[:alert] = "Nooooo~~~not allowed"
      redirect_to root_path
      return
    end

  end

end
