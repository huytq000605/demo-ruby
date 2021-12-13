class CreateMembers < ActiveRecord::Migration[6.1]
  def change
    create_table :members, {id: false} do |t|
      t.string :id
      t.string :organisation_id
      t.string :first_name
      t.string :last_name
      t.string :known_as
      t.string :email
      t.string :string
      t.string :company_email
      t.string :avatar_url
      t.string :role
      t.string :active

      t.timestamps
    end
  end
end
