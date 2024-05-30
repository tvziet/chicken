class AddIndexForNameToRoles < ActiveRecord::Migration[7.1]
  def change
    add_index :roles, :name, unique: true
  end
end
