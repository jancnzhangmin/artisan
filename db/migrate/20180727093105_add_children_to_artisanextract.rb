class AddChildrenToArtisanextract < ActiveRecord::Migration[5.1]
  def change
    add_column :artisanextracts, :children, :bigint
  end
end
