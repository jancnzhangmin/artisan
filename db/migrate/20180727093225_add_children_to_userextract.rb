class AddChildrenToUserextract < ActiveRecord::Migration[5.1]
  def change
    add_column :userextracts, :children, :bigint
  end
end
