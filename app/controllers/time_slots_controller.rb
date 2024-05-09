class TimeSlotsController < ApplicationController
    before_action :set_time_slot, only: %i[ destroy edit ]
    before_action :require_login
    before_action :require_non_guest

    def index
        @time_slots = TimeSlot.all
    end

    def new
        @time_slot = TimeSlot.new
    end

    def create
        @time_slot = TimeSlot.new(time_slot_params)

        # TODO 檢查時段重疊

        if @time_slot.save
            redirect_to time_slot_url, notice: "新增成功" # i18n: Time slot was successfully created.
        else
            flash.now[:alert] = "新增失敗" # i18n
            render :new, status: :unprocessable_entity
        end

    end

    def destroy

        if @time_slot.destroy
            redirect_to time_slots_url, notice: "刪除成功" # i18n: Time slot was successfully destroyed.
        else
            flash.now[:alert] = "刪除失敗" # i18n
            render :index, status: :unprocessable_entity # i18n: Failed to destroy the time slot.
        end

    end

    def edit
    end

    def update

        if @time_slot.update(time_slot_params)
            redirect_to time_slots_url, notice: "更新成功" # TODO i18n: Time slot was successfully updated.
        else
            flash.now[:alert] = "更新失敗" # i18n: Failed to update the time slot.
            render :index, status: :unprocessable_entity
        end

    end

    private

    def time_slot_params
        params.require(:time_slot).permit(:name, :start_at, :end_at)
    end

    def set_time_slot
        @time_slot = TimeSlot.find(params[:id])
    end

end
