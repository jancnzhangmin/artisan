class AddAttachmentIdfrontToArtisanusers < ActiveRecord::Migration[5.0]
  def self.up
    change_table :artisanusers do |t|
      t.attachment :idfront
    end
  end

  def self.down
    remove_attachment :artisanusers, :idfront
  end
end
