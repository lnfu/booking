class ReservationsController < ApplicationController
    # before_action :set_reservation, only: %i[ destroy ]
    before_action :set_room, only: %i[ create ]
    before_action :set_date, only: %i[ create ]
    # TODO before_action :require_login
    # TODO before_action :require_non_guest
    # TODO before_action :require_admin, except: %i[ show create destroy ]

    def index
        # includes 會做 JOIN 避免 N + 1 query
        @reservations = Reservation.includes(:user, :room, :time_slot).all
    end

    # def show
    #     @reservations = Reservation.includes(:user, :room, :time_slot).where(user: current_user)
    #     render :show
    # end

    def create
        if current_user.blank?
            redirect_to board_path(@room.name, date_to_str(@date)), notice: "You are not logged in."
            return
        end

        @reservation = Reservation.new(
            user_id: current_user.id,
            room_id: @room.id,
            time_slot_id: params[:time_slot_id],
            date: @date
        )

        if @reservation.save
            redirect_to board_path(@room.name, "#{@date.year}-#{@date.month}-#{@date.day}"), notice: "Reservation was successfully created."
        else
            redirect_to board_path(@room.name, "#{@date.year}-#{@date.month}-#{@date.day}"), notice: "Failed to create reservation."
        end
    end

    # def destroy
    #     @reservation.destroy!
    
    #     if @reservation.destroy
    #         redirect_to url_for(request.env["HTTP_REFERER"] || root_path), notice: "Reservation was successfully destroyed."  # TODO i18n
    #     else
    #         redirect_to url_for(request.env["HTTP_REFERER"] || root_path), alert: "Failed to destroy the reservation." # TODO i18n
    #     end
    # end

    private

    # def set_reservation
    #     @reservation = Reservation.find(params[:id])
    # end

    def set_room
        @room = Room.find(params[:room_id])
    end

    def set_date
        @date = params[:date].to_date
    end
end
