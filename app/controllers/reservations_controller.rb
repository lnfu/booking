class ReservationsController < ApplicationController
    before_action :set_reservation, only: %i[ destroy ]
    before_action :set_room, only: %i[ create ]
    before_action :set_date, only: %i[ create ]
    before_action :set_user, only: %i[ index ]
    before_action :require_login
    before_action :require_non_guest

    def index
        # includes 會做 JOIN 避免 N + 1 query
        if @user
            # 顯示指定使用者的所有預約
            if current_user.admin? || current_user == @user
                @reservations = Reservation.includes(:user, :room, :time_slot).where(user: @user)
            end
        else
            # 顯示所有使用者的所有預約
            if current_user.admin?
                @reservations = Reservation.includes(:user, :room, :time_slot).all
            end
        end
    end

    def create
        # TODO UI 要想一下怎麼提示限制

        # 檢查使用者預約數量是否超過限制
        if Setting.daily_limit != -1
            daily_count = Reservation.where(
                user_id: current_user.id, 
                date: @date
            ).count
            p Setting.daily_limit
            p daily_count

            if daily_count >= Setting.daily_limit
                # 超過當日上限
                p "test"
                return
            end    
        end

        if Setting.weekly_limit != -1
            weekly_count = Reservation.where(
                user_id: current_user.id, 
                date: @date.at_beginning_of_week..@date.at_end_of_week
            ).count
            if weekly_count >= Setting.weekly_limit
                # 超過當週上限
                return
            end        
        end

        if Setting.monthly_limit != -1
            monthly_count = Reservation.where(
                user_id: current_user.id, 
                date: @date.at_beginning_of_month..@date.at_end_of_month
            ).count
            if monthly_count >= Setting.monthly_limit
                # 超過當月上限
                return
            end
        end

        # 檢查同時段是否有在別房的預約 (如果有就禁止)
        simultaneous_count = Reservation.where(
            user_id: current_user.id, 
            date: @date,
            time_slot_id: params[:time_slot_id]
        ).count
        if simultaneous_count > 0
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

    def destroy    
        # 不能刪除以前的預約
        if @reservation.date < Date.today || (@reservation.date == Date.today && Time.parse(@reservation.time_slot.start_at.strftime("%H:%M:%S"))  < Time.parse(Time.now.strftime("%H:%M:%S")))
            redirect_to url_for(request.env["HTTP_REFERER"] || root_path), alert: "Failed to destroy the reservation."
        else
            # 確認是本人 or 管理員
            if current_user.admin? || current_user == @reservation.user
                if @reservation.destroy
                    redirect_to url_for(request.env["HTTP_REFERER"] || root_path), notice: "Reservation was successfully destroyed."  # TODO i18n
                else
                    redirect_to url_for(request.env["HTTP_REFERER"] || root_path), alert: "Failed to destroy the reservation." # TODO i18n
                end    
            end
        end
    end

    private

    def set_reservation
        @reservation = Reservation.find(params[:id]) if params[:id].present?
    end

    def set_room
        @room = Room.find(params[:room_id]) if params[:room_id].present?
    end

    def set_date
        @date = params[:date].to_date
    end

    def set_user
        @user = User.find(params[:user_id]) if params[:user_id].present?
    end
end
