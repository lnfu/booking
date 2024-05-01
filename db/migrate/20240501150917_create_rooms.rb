class CreateRooms < ActiveRecord::Migration[7.1]
  def change
    create_table :rooms do |t|
      t.string :name, null: false # 琴房名稱 e.g., 409
      t.string :password, null: false # 琴房門鎖密碼
      t.string :color, default: '#FFFFFF'

      t.timestamps
    end
    add_index :rooms, :name, unique: true
  end
end
