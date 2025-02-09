class ApplicationController < ActionController::Base
  before_action :authenticate_user!, except: [:top, :about]
  before_action :configure_permitted_parameters, if: :devise_controller?
 
  def after_sign_in_path_for(resource)
    user_path(@user.id)
  end
  
  def after_sign_out_path_for(resource_or_scope)
    flash[:notice] = "You have logged out successfully."
    root_path
  end

  def index
    @users = User.all
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :email, :password, :password_confirmation])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :email])
  end
end
