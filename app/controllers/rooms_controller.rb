class RoomsController < ApplicationController
    before_action :require_login

    def index
        @rooms = Room.all
    end
end
