class CreateTimeSlots < ActiveRecord::Migration[7.1]
  def change
    create_table :time_slots do |t|
      t.string :name, null:false # 沒特別用途 1 ~ 24
      t.time :start_at, null: false
      t.time :end_at, null: false

      t.timestamps
    end
    add_index :time_slots, :name
  end
end
