class AddUseridToArtisanuser < ActiveRecord::Migration[5.1]
  def change
    add_column :artisanusers, :user_id, :bigint
  end
end
