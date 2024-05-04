class LimitsController < ApplicationController

    def index
        @daily_limit = Setting.daily_limit
        @weekly_limit = Setting.weekly_limit
        @monthly_limit = Setting.monthly_limit
    end

    def update
        if params[:daily_limit_enabled] == "1"
            @daily_limit = params[:daily_limit].to_i
        else
            @daily_limit = -1
        end
        if params[:weekly_limit_enabled] == "1"
            @weekly_limit = params[:weekly_limit].to_i
        else
            @weekly_limit = -1
        end
        if params[:monthly_limit_enabled] == "1"
            @monthly_limit = params[:monthly_limit].to_i
        else
            @monthly_limit = -1
        end

        # 更新
        Setting.daily_limit = @daily_limit if Setting.daily_limit != @daily_limit
        Setting.weekly_limit = @weekly_limit if Setting.weekly_limit != @weekly_limit
        Setting.monthly_limit = @monthly_limit if Setting.monthly_limit != @monthly_limit

        redirect_to limits_path, notice: "Limits were successfully updated."

    end
end
