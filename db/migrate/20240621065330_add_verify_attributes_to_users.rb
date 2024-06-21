class AddVerifyAttributesToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :confirmation_token, :string
    add_column :users, :is_verified, :boolean, default: false
  end
end
