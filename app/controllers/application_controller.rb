class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  helper_method :current_user
  helper_method :logged_in?

  protected

  def logged_in?
    !!session[:user_id]
  end

  def current_user
      @current_user ||= User.find_by_id!(session[:user_id]) if logged_in?
  end

  def require_login
    redirect_to login_path unless logged_in?
  end
end
