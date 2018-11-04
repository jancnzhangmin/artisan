class AddUpidToArtisanuser < ActiveRecord::Migration[5.1]
  def change
    add_column :artisanusers, :up_id, :bigint
  end
end
