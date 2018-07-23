class AddHeadurlToArtisanuser < ActiveRecord::Migration[5.1]
  def change
    add_column :artisanusers, :headurl, :string
    add_column :artisanusers, :status, :integer
  end
end
