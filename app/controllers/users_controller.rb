class UsersController < ApplicationController
    before_action :set_user, only: %i[ destroy promote_to_regular promote_to_admin ]
    before_action :require_login, except: %i[ new create forgot_password_form forgot_password reset_password_form reset_password]
    before_action :require_non_guest, except: %i[ pending ]
    # before_action :require_admin

    def index
        @users = User.all.order(:role)
    end

    def new
        @user = User.new
    end

    def create
        @user = User.new(user_params)

        if User.exists?(nick: @user.nick)
            flash[:alert] = "使用者名稱重複"
            render :new, status: :unprocessable_entity
            return
        end

        if User.exists?(name: @user.name)
            flash[:alert] = "學號重複"
            render :new, status: :unprocessable_entity
            return
        end

        if User.exists?(email: @user.email)
            flash[:alert] = "電子郵件重複"
            render :new, status: :unprocessable_entity
            return
        end

        @user.role = :guest

        if @user.save
            # 回到登入頁面
            redirect_to login_path, notice: "User was successfully created." # TODO i18n
        else
            render :new, status: :unprocessable_entity
        end
    end

    def destroy
        if current_user == @user
            if @user.destroy
                reset_session # 如果把自己刪除, 就要登出
                # 回到登入頁面
                redirect_to login_path, notice: "Your account has been successfully deleted. You have been logged out." # TODO i18n
            else
                redirect_to users_url, alert: "Failed to destroy the user." # TODO i18n
            end
        else
            if @user.destroy
                redirect_to users_url, notice: "User was successfully destroyed." # TODO i18n
            else
                redirect_to users_url, alert: "Failed to destroy the user." # TODO i18n
            end    
        end
    end

    def promote_to_regular
        if @user.guest?
            @user.update(role: :regular)
            redirect_to users_url, notice: "User promoted to regular successfully."
        else
            redirect_to users_url, alert: "Only guests can be promoted to regular users."
        end
    end
    
    def promote_to_admin
        if @user.regular?
            @user.update(role: :admin)
            redirect_to users_url, notice: "User promoted to admin successfully."
        else
            redirect_to users_url, alert: "Only regular users can be promoted to admin users."
        end
    end

    def pending
    end

    def forgot_password_form
    end

    def forgot_password
        # 填寫學號
        @user = User.find_by(name: params[:name])

        if @user.blank?
            # TODO
            return
        end
      
        if @user
            @user.generate_password_reset_token!
            # 發送包含重設密碼連接的電子郵件
            # MailerClass.reset_password_instructions(@user).deliver_now
            UserMailer.forgot_password_email(@user).deliver_now
            redirect_to forgot_password_path, notice: "Password reset instructions have been sent to your email."
        else
            flash.now[:alert] = "Student ID not found."
            render :forgot_password_form
        end
    end

    # 顯示輸入新密碼的表單
    def reset_password_form
        validate_token
    end
      
    def reset_password
        validate_token
    
        password = params[:password]
        password_confirmation = params[:password_confirmation]
        if @user.update(
            password: password, 
            password_confirmation: password_confirmation,
            password_reset_token: nil,
            password_reset_token_expire_at: nil
        )
            redirect_to login_path, notice: "Password was successfully updated."
        else
            render :reset_password_form
        end
    end

    private

    def user_params
        params.require(:user).permit(:name, :email, :nick, :password, :password_confirmation)
    end

    def set_user
        @user = User.find(params[:id])
    end

    def validate_token
        @token = params[:token]
        @user = User.find(params[:id])
        redirect_to login_path, alert: "Invalid or expired reset password link." if @user.blank? || 
            @token.blank? || @user.password_reset_token.blank? || 
            @user.password_reset_token_expire_at.blank? || 
            @token != @user.password_reset_token || 
            Time.now > @user.password_reset_token_expire_at
    end

end
