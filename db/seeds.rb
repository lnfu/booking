require 'bcrypt'

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
Rails.application.credentials.rooms.each do |room|
  Room.create!(
    name: room[:name],
    password: room[:password],
    color: '#FFFFFF'
  )
end

# User
User.destroy_all
User.create!(
  name: '111111111',
  email: 'test.guest@nycu.edu.tw',
  nickname: '測試用訪客帳號',
  role: :guest,
  password_digest: BCrypt::Password.create('111111')
)
User.create!(
  name: '222222222',
  email: 'test.regular@nycu.edu.tw',
  nickname: '測試用一般帳號',
  role: :regular,
  password_digest: BCrypt::Password.create('222222')
)
User.create!(
  name: '333333333',
  email: 'test.admin@nycu.edu.tw',
  nickname: '測試用管理員帳號',
  role: :admin,
  password_digest: BCrypt::Password.create('333333')
)
