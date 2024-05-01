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

# Rooms
# TODO 改成真的房間資料
Room.destroy_all
Room.create!(
    name: '444',
    password: '123456',
    color: '#FFFFFF',
)

# User
# TODO 改成預設只有一個管理員使用者, 並且帳號密碼不明文寫
User.destroy_all
User.create!(
    name: 'test_guest',
    email: 'guest@test.com',
    nick: 'tg',
    password_digest: BCrypt::Password.create('test guest'),
    role: :guest,
)
User.create!(
    name: 'test_regular',
    email: 'regular@test.com',
    nick: 'tr',
    password_digest: BCrypt::Password.create('test regular'),
    role: :regular,
)
User.create!(
    name: 'test_admin',
    email: 'admin@test.com',
    nick: 'ta',
    password_digest: BCrypt::Password.create('test admin'),
    role: :admin,
)
