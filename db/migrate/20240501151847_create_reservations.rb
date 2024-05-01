class CreateReservations < ActiveRecord::Migration[7.1]
  def change
    create_table :reservations do |t|
      t.references :time_slot, null: false, foreign_key: true
      t.references :room, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.date :date

      t.timestamps
    end
  end
end
