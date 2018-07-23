class AddPaytypeToBartask < ActiveRecord::Migration[5.1]
  def change
    add_column :bartasks, :paytype, :integer
  end
end
