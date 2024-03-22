class ReservationsController < ApplicationController
    before_action :set_reservation, only: %i[ destroy ]
    before_action :set_room, only: %i[ create ]
    before_action :set_date, only: %i[ create ]
    before_action :require_login
    before_action :require_non_guest
    before_action :require_admin, except: %i[ show create destroy ]

    def index
        @reservations = Reservation.includes(:user, :room, :time_slot).all
    end

    def show
        @reservations = Reservation.includes(:user, :room, :time_slot).where(user: current_user)
        render :show
    end

    def create
        @reservation = Reservation.new(
            user_id: current_user.id,
            room_id: @room.id,
            time_slot_id: params[:time_slot_id],
            date: @date
        )
        if @reservation.save
            redirect_to board_path(@room.name, @date.year, @date.month, @date.day), notice: "Reservation was successfully created."
        else
            redirect_to board_path(@room.name, @date.year, @date.month, @date.day), notice: "Failed to create reservation."
        end
    end

    def destroy
        @reservation.destroy!
        redirect_to url_for(request.env["HTTP_REFERER"] || root_path), notice: "Reservation was successfully deleted."
    end

    private

    def set_reservation
        @reservation = Reservation.find(params[:id])
    end

    def set_room
        @room = Room.find(params[:room_id])
    end

    def set_date
        @date = params[:date].to_date
    end
end
