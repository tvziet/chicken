class AddIndexForNameToOrganizations < ActiveRecord::Migration[7.1]
  def change
    add_index :organizations, :name
  end
end
