class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :room
  belongs_to :time_slot
end
