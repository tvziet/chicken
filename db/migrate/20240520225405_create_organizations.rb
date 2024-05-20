class CreateOrganizations < ActiveRecord::Migration[7.1]
  def change
    create_table :organizations do |t|
      t.string :name
      t.string :short_name
      t.string :email
      t.string :url
      t.string :street
      t.string :city
      t.string :state
      t.string :zipcode

      t.timestamps
    end

    add_index :organizations, :short_name
  end
end
