class CreateReservations < ActiveRecord::Migration[7.2]
  def change
    create_table :reservations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :room, null: false, foreign_key: true
      t.references :time_slot, null: false, foreign_key: true
      t.date :date, null: false

      t.timestamps
    end

    add_index :reservations, [ :room_id, :time_slot_id, :date ], unique: true
  end
end
