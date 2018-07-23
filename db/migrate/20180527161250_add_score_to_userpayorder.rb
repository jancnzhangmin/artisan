class AddScoreToUserpayorder < ActiveRecord::Migration[5.1]
  def change
    add_column :userpayorders, :score, :float
  end
end
