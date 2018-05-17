class CreateArtisanusers < ActiveRecord::Migration[5.1]
  def change
    create_table :artisanusers do |t|
      t.string :openid
      t.string :password_digest
      t.string :username
      t.string :province
      t.string :city
      t.string :district
      t.string :valicode
      t.datetime :valitime

      t.timestamps
    end
  end
end
