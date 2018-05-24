class AddAttachmentBartaskproimageToBartaskproimages < ActiveRecord::Migration[5.1]
  def self.up
    change_table :bartaskproimages do |t|
      t.attachment :bartaskproimage
    end
  end

  def self.down
    remove_attachment :bartaskproimages, :bartaskproimage
  end
end
