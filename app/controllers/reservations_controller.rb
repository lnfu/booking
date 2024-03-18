class ReservationsController < ApplicationController
    before_action :set_reservation, only: %i[ destroy ]

    def index
        @reservations = Reservation.includes(:user, :room, :time_slot).all
    end

    def create
    end

    def destroy
    end

    private

    def set_reservation
        @reservation = Reservation.find(params[:id])
    end
end
