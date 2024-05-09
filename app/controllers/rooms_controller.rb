class RoomsController < ApplicationController
    before_action :set_room, only: %i[ destroy edit update ]
    before_action :require_login
    before_action :require_non_guest
    before_action :require_admin, except: %i[ index ] # 一般社員只能看房間列表

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
            redirect_to rooms_url, notice: "新增成功" # i18n: Room was successfully created.
        else
            flash.now[:alert] = "新增失敗" # i18n
            render :new, status: :unprocessable_entity
        end
    end

    def destroy
        if @room.destroy
            redirect_to rooms_url, notice: "刪除成功" # i18n: Room was successfully destroyed.
        else
            flash.now[:alert] = "刪除失敗" # i18n
            render :index, status: :unprocessable_entity # i18n: Failed to destroy the room.
        end
    end

    def edit
    end

    def update
        if @room.update(room_params)
            redirect_to rooms_url, notice: "更新成功" # TODO i18n: Room was successfully updated.
        else
            flash.now[:alert] = "更新失敗" # i18n: Failed to update the room.
            render :index, status: :unprocessable_entity
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
