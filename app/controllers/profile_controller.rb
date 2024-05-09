class ProfileController < ApplicationController
    before_action :set_user, only: [ :show, :update ]
    before_action :require_login

    def show
    end

    # TODO 和 user controller 整合？
    def update
        if @user.update(user_params)
            redirect_to profile_path, notice: "成功更新個人資料" # i18n: Profile was successfully updated.
        else
            render :show
        end
    end

    private

    def set_user
        @user = current_user
    end

    def user_params
        params.require(:user).permit(:nick, :password)
    end
end
