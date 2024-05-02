class ApplicationController < ActionController::Base
    helper_method :current_user

    protected

    def current_user
        @current_user ||= session[:user_id] && User.find_by_id(session[:user_id])
    end  
end
