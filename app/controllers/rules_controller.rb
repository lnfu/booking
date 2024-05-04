class RulesController < ApplicationController
    def index
        @daily_limit = Setting.daily_limit
        @weekly_limit = Setting.weekly_limit
        @monthly_limit = Setting.monthly_limit
    end
end
