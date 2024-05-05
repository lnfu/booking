require 'bcrypt'

# TimeSlots
# 因為時區問題, 要使用 zone.local
TimeSlot.destroy_all
names = (1..24).to_a.map(&:to_s)
start_times = (0..23).to_a.map { |hour| Time.zone.local(2000, 1, 1, hour, 0, 0) }
end_times = (1..24).to_a.map { |hour| Time.zone.local(2000, 1, 1, hour, 0, 0) }
24.times do |i|
    TimeSlot.create!(
        name: names[i],
        start_at: start_times[i],
        end_at: end_times[i],
    )
end

User.create!(
    name: ENV.fetch("ADMIN_USER"),
    email: ENV.fetch("ADMIN_EMAIL"),
    nick: ENV.fetch("ADMIN_USER"),
    password_digest: BCrypt::Password.create(ENV.fetch("ADMIN_PASSWORD")),
    role: :admin,
)
