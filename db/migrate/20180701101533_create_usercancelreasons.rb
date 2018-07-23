class CreateUsercancelreasons < ActiveRecord::Migration[5.1]
  def change
    create_table :usercancelreasons do |t|
      t.text :reason

      t.timestamps
    end
  end
end
