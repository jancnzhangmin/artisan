class CreateAdmins < ActiveRecord::Migration[5.1]
  def change
    create_table :admins do |t|
      t.string :login
      t.string :password_digest
      t.string :name
      t.integer :status

      t.timestamps
    end
  end
end
