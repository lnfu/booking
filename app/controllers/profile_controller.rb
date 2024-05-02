class ProfileController < ApplicationController
    before_action :set_user, only: [ :show, :update ]
    # TODO before_action :require_login

    def show
        # TODO redirect_to login_path if !current_user
    end

    def update
        if @user.update(user_params)
            redirect_to profile_path, notice: "Profile was successfully updated."
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
