class AddArtisanuseridToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :artisanuser_id, :bigint
  end
end
