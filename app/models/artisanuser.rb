class Artisanuser < ApplicationRecord
  has_and_belongs_to_many :servicecaps
  has_many :offers
  has_many :bartaskpros
  has_many :incomes
  has_many :widthdraws
  has_many :withdrawpwds
  has_attached_file :idfront, :url => "/:attachment/:id/:basename.:extension",  :path => ":rails_root/public/:attachment/:id/:basename.:extension"
  do_not_validate_attachment_file_type :idfront
  has_attached_file :idback, :url => "/:attachment/:id/:basename.:extension",  :path => ":rails_root/public/:attachment/:id/:basename.:extension"
  do_not_validate_attachment_file_type :idback



end
