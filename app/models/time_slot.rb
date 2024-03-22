class TimeSlot < ApplicationRecord
    has_many :reservations, dependent: :delete_all
end
