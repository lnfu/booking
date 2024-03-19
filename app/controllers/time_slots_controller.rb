class TimeSlotsController < ApplicationController
    before_action :set_time_slot, only: %i[ destroy edit ]
    before_action :require_login

    def index
        @time_slots = TimeSlot.all
    end

    def new
        @time_slot = TimeSlot.new
    end

    def create
        @time_slot = TimeSlot.new(time_slot_params)

        if @time_slot.save
            redirect_to time_slot_url(@time_slot), notice: "Time slot was successfully created."
        else
            render :new, status: :unprocessable_entity
        end
    end

    def destroy
        # TODO 刪除 callback (連帶刪除相關的資料)
        @time_slot.destroy!
        redirect_to time_slots_url, notice: "Time slot was successfully destroyed."
    end

    def edit
    end

    private

    def time_slot_params
        params.require(:time_slot).permit(:name, :start_at, :end_at)
    end

    def set_time_slot
        @time_slot = TimeSlot.find(params[:id])
    end
end
