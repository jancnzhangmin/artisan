class Bartaskproimage < ApplicationRecord
  belongs_to :bartaskpro
  has_attached_file :bartaskproimage, :url => "/:attachment/:id/:basename.:extension",  :path => ":rails_root/public/:attachment/:id/:basename.:extension"
  do_not_validate_attachment_file_type :bartaskproimage
end
