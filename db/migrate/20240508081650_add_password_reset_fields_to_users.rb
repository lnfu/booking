class AddPasswordResetFieldsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :password_reset_token, :string
    add_column :users, :password_reset_token_expire_at, :datetime
  end
end
