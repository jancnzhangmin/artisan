class AddSummaryToIncome < ActiveRecord::Migration[5.1]
  def change
    add_column :incomes, :summary, :string
  end
end
