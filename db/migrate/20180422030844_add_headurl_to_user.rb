class AddHeadurlToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :headurl, :string
    add_column :users, :valicode, :string
    add_column :users, :valitime, :datetime
  end
end
