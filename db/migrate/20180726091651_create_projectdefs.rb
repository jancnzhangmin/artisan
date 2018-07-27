class CreateProjectdefs < ActiveRecord::Migration[5.1]
  def change
    create_table :projectdefs do |t|
      t.string :project

      t.timestamps
    end
  end
end
