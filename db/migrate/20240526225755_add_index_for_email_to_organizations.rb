class AddIndexForEmailToOrganizations < ActiveRecord::Migration[7.1]
  def change
    add_index :organizations, :email, unique: true
  end
end
