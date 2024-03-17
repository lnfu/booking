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

Room.destroy_all
Rails.application.credentials.rooms.each do |room|
  Room.create!(
    name: room[:name],
    password: room[:password],
    color: '#FFFFFF'
  )
end
