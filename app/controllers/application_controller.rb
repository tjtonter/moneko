class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :update_sanitized_params, if: :devise_controller?
  before_filter :configure_permitted_parameters, if: :devise_controller?
  attr_accessor :login

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to new_user_session_path, :alert=>exception.message
  end

  before_filter do
    resource = controller_name.singularize.to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) {|u| u.permit(:current_password, :name, :username, :email, :password, :password_confirmation, :gcal, roles: [])}
    devise_parameter_sanitizer.for(:account_update) {|u| u.permit(:current_password, :name, :username, :email, :password, :password_confirmation, :gcal, roles: [])}
  end
  def update_sanitized_params
    devise_parameter_sanitizer.for(:sign_up) {|u| u.permit(:login, :username, :email, :password, :name, :password_confirmation)}
    devise_parameter_sanitizer.for(:sign_in) {|u| u.permit(:login, :username, :email, :password, :password_confirmation, :remember_me)}
  end

  def after_sign_in_path_for(resource)
    user_path(current_user)
  end  
end
