class Reservation < ApplicationRecord
  belongs_to :time_slot
  belongs_to :room
  belongs_to :user
end
