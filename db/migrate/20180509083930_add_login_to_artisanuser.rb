class AddLoginToArtisanuser < ActiveRecord::Migration[5.1]
  def change
    add_column :artisanusers, :login, :string
  end
end
