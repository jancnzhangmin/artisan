class AddNeedreceivableToBartaskpro < ActiveRecord::Migration[5.1]
  def change
    add_column :bartaskpros, :needreceivable, :integer
  end
end
