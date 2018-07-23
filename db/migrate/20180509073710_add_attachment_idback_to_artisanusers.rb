class AddAttachmentIdbackToArtisanusers < ActiveRecord::Migration[5.0]
  def self.up
    change_table :artisanusers do |t|
      t.attachment :idback
    end
  end

  def self.down
    remove_attachment :artisanusers, :idback
  end
end
