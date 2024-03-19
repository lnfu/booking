class BoardsController < ApplicationController
    before_action :set_room, only: %i[ show ]
    before_action :set_target_date, only: %i[ show ]
    before_action :require_login

    def index
        redirect_to board_today_path(id: Rails.application.config.default_room)
    end

    def show_today
        @today = Date.today
        redirect_to board_path(id: params[:id], year: @today.year, month: @today.month, day: @today.day)
    end

    def show
        @time_slots = TimeSlot.all.order(start_at: :asc)
        @prev_week_date = @target_date - 7
        @next_week_date = @target_date + 7
        # weekdays = t(".weekdays").map(&:last)
        # @week_days = [ "星期一", "星期二", "星期三", "星期四", "星期五", "星期六", "星期日" ]
        @week_dates = (@target_date.beginning_of_week..@target_date.end_of_week).to_a

        reservations = Reservation.where(
            room_id: @room.id,
            date: @week_dates
        )

        @data = Array.new(7, Hash.new())
        @week_dates.each do |week_date|
            @data[week_date.cwday - 1] = { "date" => week_date }
        end
        reservations.each do |reservation|
            @data[reservation.date.cwday - 1].store(reservation.time_slot, reservation)
        end
    end

    private

    def set_room
        @room = Room.find_by(name: params[:id])
      # redirect_to_default_board_today if @room.nil?
    end

    def set_target_date
        @target_date = Date.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)
    end
end
