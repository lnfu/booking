class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :name, null: false # 學號
      t.string :email, null: false
      t.string :nickname, null: false # 顯示名稱
      t.string :password_digest
      t.integer :role, null: false

      t.timestamps
    end

    add_index :users, :name, unique: true
    add_index :users, :email, unique: true
  end
end
