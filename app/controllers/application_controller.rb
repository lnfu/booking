class ApplicationController < ActionController::Base
    helper_method :current_user
    helper_method :date_to_str
    helper_method :mobile_device?

    protected

    def mobile_device?
        return request.user_agent =~ /Mobile|webOS/
    end

    def current_user
        @current_user ||= session[:user_id] && User.find_by_id(session[:user_id])
    end  

    # 轉成 route param
    def date_to_str(date)
        return "#{"%04d" % date.year}-#{"%02d" % date.month}-#{"%02d" % date.day}"
    end

    def require_login
        if current_user.blank?
            session[:return_to] = request.fullpath if request.get?
            redirect_to login_path, alert: "請先登入" # i18n: You are not logged in.
        end
    end

    def require_non_guest
        if current_user&.guest?
            redirect_to pending_path
        end
    end
    
    def require_admin
        unless current_user&.admin?
            redirect_to root_path, alert: "您不是管理員" # i18n: You are not admin.
        end
    end
        
end
