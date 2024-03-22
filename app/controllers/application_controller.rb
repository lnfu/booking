class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  helper_method :current_user
  helper_method :logged_in?
  layout :set_layout
  def set_layout
     if logged_in?
       "application"
     else
       "login"
     end
  end

  protected

  def logged_in?
    !!session[:user_id] && User.exists?(session[:user_id])
  end

  def current_user
      @current_user ||= User.find_by_id!(session[:user_id]) if logged_in?
  end

  def require_login
    redirect_to login_path, alert: "Please login first." unless logged_in?
  end

  def require_non_guest
    redirect_to root_path, alert: "You are not verified." if current_user&.guest?
  end

  def require_admin
    redirect_to root_path, alert: "You are not admin." unless current_user&.admin?
  end
end
