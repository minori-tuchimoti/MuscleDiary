# frozen_string_literal: true

class Admin::SessionsController < Devise::SessionsController
  layout 'admin' # ここを追加
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
  
  def create
    super
  end

  def authenticated_admin_root_path
    admin_dashboards_path
  end
  
  

  protected
 
  def after_sign_in_path_for(resource)
    if resource.is_a?(Admin)
      admin_dashboards_path
    else
      public_users_path
    end
  end
 
  def after_sign_out_path_for(resource_or_scope)
    new_admin_session_path
  end
end
