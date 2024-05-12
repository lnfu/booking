class UsersController < ApplicationController
    before_action :require_login, except: %i[ new create forgot_password_form forgot_password reset_password_form reset_password]
    before_action :require_non_guest, except: %i[ pending ]
    before_action :require_admin, except: %i[ new create forgot_password_form forgot_password reset_password_form reset_password pending ]
    before_action :set_user, only: %i[ destroy promote_to_regular promote_to_admin demote_to_guest clear_reservations ]

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
            redirect_to login_path, notice: "註冊成功" # TODO i18n: User was successfully created.
        else
            flash.now[:alert] = "註冊失敗" # i18n: 
            render :new, status: :unprocessable_entity
        end
    end

    def destroy

        reservations = Reservation.where(user_id: @user.id)
        if reservations.any?
            redirect_to users_url, alert: "請先清除該使用的所有預約" # i18n: 
        else

            if current_user == @user
                if @user.destroy
                    reset_session # 如果把自己刪除, 就要登出
                    # 回到登入頁面
                    redirect_to login_path, notice: "刪除成功，您已登出。" # i18n: Your account has been successfully deleted. You have been logged out.
                else
                    redirect_to users_url, alert: "刪除失敗" # i18n: Failed to destroy the user.
                end
            else
                if @user.destroy
                    redirect_to users_url, notice: "刪除成功" # i18n: User was successfully destroyed.
                else
                    redirect_to users_url, alert: "刪除失敗" # i18n: Failed to destroy the user.
                end    
            end

        end

    end

    def promote_to_regular
        if @user.guest?
            @user.update(role: :regular)
            redirect_to users_url, notice: "User promoted to regular successfully."
        else
            redirect_to users_url, alert: "Only guests can be promoted to regular users." # i18n: 
        end
    end
    
    def promote_to_admin
        if @user.regular?
            @user.update(role: :admin)
            redirect_to users_url, notice: "User promoted to admin successfully."
        else
            redirect_to users_url, alert: "Only regular users can be promoted to admin users." # i18n: 
        end
    end

    def demote_to_guest
        if @user.guest?
            redirect_to users_url, alert: "Only non-guest users can be demoted to guest users." # i18n: 
        else
            @user.update(role: :guest)
            redirect_to users_url, notice: "User demoted to guest successfully."
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
            flash.now[:alert] = "找不到使用者" # i18n: Student ID not found.
            render :forgot_password_form, status: :unprocessable_entity
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
            redirect_to login_path, notice: "重設密碼成功" # i18n: Password was successfully updated.
        else
            flash.now[:alert] = "重設密碼失敗" # i18n:
            render :reset_password_form
        end
    end

    def clear_reservations
        p @user.nick

        reservations = Reservation.where(user_id: @user.id)
        
        if reservations.destroy_all
            redirect_to users_path, notice: "已成功刪除 #{@user.name} 的所有預約"
        else
            redirect_to users_url, notice: "刪除 #{@user.name} 的預約失敗" # i18n: 
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
        # i18n: Invalid or expired reset password link.
        redirect_to login_path, alert: "連結無效" if @user.blank? || 
            @token.blank? || @user.password_reset_token.blank? || 
            @user.password_reset_token_expire_at.blank? || 
            @token != @user.password_reset_token || 
            Time.now > @user.password_reset_token_expire_at
    end

end
