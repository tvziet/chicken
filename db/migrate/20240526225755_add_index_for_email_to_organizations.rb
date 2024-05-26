class AddIndexForEmailToOrganizations < ActiveRecord::Migration[7.1]
  def change
    add_index :organizations, :email
  end
end
