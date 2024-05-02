class UsersController < ApplicationController
    before_action :set_user, only: %i[ destroy promote_to_regular promote_to_admin ]
    # before_action :require_login
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
            redirect_to user_url(@user), notice: "User was successfully created." # TODO i18n
        else
            render :new, status: :unprocessable_entity
        end
    end

    def destroy
        if current_user == @user
            if @user.destroy
                reset_session # 如果把自己刪除, 就要登出
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

    private

    def user_params
        params.require(:user).permit(:name, :email, :nick, :password)
    end

    def set_user
        @user = User.find(params[:id])
    end

end
