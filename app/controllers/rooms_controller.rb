class RoomsController < ApplicationController
    before_action :require_login
    before_action :require_non_guest

    def index
        @rooms = Room.all
    end
end
