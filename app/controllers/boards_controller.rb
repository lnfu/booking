class BoardsController < ApplicationController
    before_action :set_room, only: %i[ show ]
    before_action :set_target_date, only: %i[ show ]

    def index
        # 預設顯示 409
        redirect_to board_path(id: "409")
    end

    def show
        @data = Array.new(7, Hash.new())

        @time_slots = TimeSlot.all.order(start_at: :asc)

        @week_dates = (@target_date.beginning_of_week..@target_date.end_of_week).to_a
        @week_dates.each do |week_date|
            @data[week_date.cwday - 1] = { "date" => week_date } # 紀錄該日的日期
        end

        reservations = Reservation.where(
            room_id: @room.id,
            date: @week_dates
        )
        reservations.each do |reservation|
            @data[reservation.date.cwday - 1].store(reservation.time_slot, reservation) # 紀錄該日的所有時段的預約
        end
    end

    private

    def set_room
        @room = Room.find_by(name: params[:id])
        # TODO redirect_to_default_board_today if @room.nil?
    end

    # 要看的日期 (會顯示包含該日期的整週)
    # 如果日期格式有問題 or 沒有給定日期 => 顯示今日
    def set_target_date
        if params[:date].blank?
            @target_date = Date.today
            return
        end
        
        begin
            @target_date = Date.parse(params[:date])
        rescue ArgumentError => _
            @target_date = Date.today
        end
    end
end
