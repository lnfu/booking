class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :name, null: false # 學號
      t.string :email, null: false
      t.string :nick # 暱稱, 預設同學號
      t.string :password_digest, null: false
      t.integer :role, null: false # 角色: guest|regular|admin
      t.time :email_verified_at

      t.timestamps
    end
    add_index :users, :name, unique: true
  end
end
