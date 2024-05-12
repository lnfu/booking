class BoardsController < ApplicationController
    before_action :set_room, only: %i[ show ]
    before_action :set_target_date, only: %i[ show ]

    def index
        first_room = Room.first

        if first_room.present?
            redirect_to board_path(id: first_room.name)
        else
            # TODO 沒有琴房時
            redirect_to rails_health_check_path
        end
    end

    def show
        @time_slots = TimeSlot.all.sort_by { |time_slot| [time_slot.start_at.hour, time_slot.start_at.min, time_slot.start_at.sec] }

        @week_dates = (@target_date.beginning_of_week..@target_date.end_of_week).to_a
        # TODO 也許 @week_dates 也放到 cache? (但是因為沒有查 db, 所以好像也不會慢)

        if Rails.cache.exist?(@target_date.beginning_of_week.to_s())
            @data = Rails.cache.read(@target_date.beginning_of_week.to_s)

        else
            # 從資料庫拿
            @data = Array.new(7, Hash.new())

            @week_dates.each do |week_date|
                @data[week_date.cwday - 1] = { "date" => week_date } # 紀錄該日的日期
            end
    
            # TODO 驗證 @room 在資料庫
            reservations = Reservation.where(
                room_id: @room.id,
                date: @week_dates
            )
            reservations.each do |reservation|
                @data[reservation.date.cwday - 1].store(reservation.time_slot, reservation) # 紀錄該日的所有時段的預約
            end    

            Rails.cache.write(@target_date.beginning_of_week.to_s, @data, expires_in: 1.hour)
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
