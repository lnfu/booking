class RoomsController < ApplicationController
    before_action :set_room, only: %i[ destroy edit update ]
    # TODO before_action :require_login
    # TODO before_action :require_non_guest

    def index
        @rooms = Room.all
    end

    def new
        @room = Room.new
    end

    def create
        @room = Room.new(room_params)

        # TODO 檢查時段重疊

        if @room.save
            redirect_to rooms_url, notice: "Room was successfully created." # TODO i18n
        else
            render :new, status: :unprocessable_entity
        end
    end

    def destroy
        if @room.destroy
            redirect_to rooms_url, notice: "Room was successfully destroyed." # TODO i18n
        else
            redirect_to rooms_url, alert: "Failed to destroy the room." # TODO i18n
        end
    end

    def edit
    end

    def update
        if @room.update(room_params)
            redirect_to rooms_url, notice: "Room was successfully updated." # TODO i18n
        else
            redirect_to rooms_url, alert: "Failed to update the room." # TODO i18n
        end
    end

    private

    def room_params
        params.require(:room).permit(:name, :password, :color)
    end

    def set_room
        @room = Room.find(params[:id])
    end

end
