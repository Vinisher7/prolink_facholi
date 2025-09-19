class FixResetPasswordTokenIndexOnUsers < ActiveRecord::Migration[7.1]
  def change
    # First, remove the old, problematic index
    remove_index :users, :reset_password_token, name: "index_users_on_reset_password_token"

    # Then, add a new index that only enforces uniqueness when the token is NOT NULL
    add_index :users, :reset_password_token, unique: true, where: "reset_password_token IS NOT NULL"
  end
end