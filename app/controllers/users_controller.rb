class UsersController < ApplicationController
    before_action :set_user, except: %i[ index ]
    before_action :require_login
    before_action :require_admin

    def index
        @users = User.all
    end

    def destroy
        @user.destroy!
        redirect_to users_url, notice: "User was successfully destroyed."
    end

    def upgrade_guest_to_regular
        check_user_role("guest")
        update_user_role("regular")
    end

    # def downgrade_regular_to_guest
    #     check_user_role("regular")
    #     update_user_role("guest")
    # end

    def upgrade_regular_to_admin
        check_user_role("regular")
        update_user_role("admin")
    end

    # def downgrade_admin_to_regular
    #     check_user_role("admin")
    #     update_user_role("regular")
    # end

    private

    def set_user
        @user = User.find(params[:id])
    end

    def check_user_role(role)
        unless @user.role == role
            redirect_to users_path
        end
    end

    def update_user_role(role)
        @user.update(role: role)
        redirect_to users_path
    end
end
