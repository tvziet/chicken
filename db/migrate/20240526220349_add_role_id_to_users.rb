class AddRoleIdToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :role_id, :uuid
    add_index :users, :role_id
  end
end
