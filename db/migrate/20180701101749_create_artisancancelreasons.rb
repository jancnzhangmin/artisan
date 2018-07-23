class CreateArtisancancelreasons < ActiveRecord::Migration[5.1]
  def change
    create_table :artisancancelreasons do |t|
      t.text :reason

      t.timestamps
    end
  end
end
