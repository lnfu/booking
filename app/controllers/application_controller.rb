class ApplicationController < ActionController::Base
    helper_method :current_user
    helper_method :date_to_str

    protected

    def current_user
        @current_user ||= session[:user_id] && User.find_by_id(session[:user_id])
    end  

    # 轉成 route param
    def date_to_str(date)
        return "#{"%04d" % date.year}-#{"%02d" % date.month}-#{"%02d" % date.day}"
    end
end
