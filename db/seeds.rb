require 'bcrypt'

# Reservation
Reservation.destroy_all
# user = User.find_by(name: '222222222') # 2號使用者
# if user.present?
#   rooms = Room.all
#   today = Date.today
#   rooms.each do |room|
#     TimeSlot.all.each do |time_slot|
#       Reservation.create!(
#         user_id: user.id,
#         room_id: room.id,
#         time_slot_id: time_slot.id,
#         date: today
#       )
#     end
#   end
# end

# TimeSlot
TimeSlot.destroy_all
# 注意時區問題! (要使用 zone.local 不能直接用 new)
names = (1..24).to_a.map(&:to_s)
start_times = (0..23).to_a.map { |hour| Time.zone.local(2000, 1, 1, hour, 0, 0) }
end_times = (1..24).to_a.map { |hour| Time.zone.local(2000, 1, 1, hour, 0, 0) }
24.times do |i|
  TimeSlot.create!(
    name: names[i],
    start_at: start_times[i],
    end_at: end_times[i]
  )
end

# Room
Room.destroy_all
rooms = Rails.application.credentials.rooms
if rooms.present?
  rooms.each do |room|
    Room.create!(
      name: room[:name],
      password: room[:password],
      color: '#FFFFFF'
    )
  end
end

# User
User.destroy_all
users = Rails.application.credentials.users
if users.present?
  users.each do |user|
    User.create!(
      name: user[:name],
      email: user[:email],
      nickname: user[:nickname],
      role: user[:role],
      password_digest: BCrypt::Password.create(user[:password])
    )
  end
end
