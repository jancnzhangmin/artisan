class AddReceivableToBartaskpro < ActiveRecord::Migration[5.1]
  def change
    add_column :bartaskpros, :receivable, :integer
  end
end
