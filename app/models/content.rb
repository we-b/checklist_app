class Content < ActiveRecord::Base

  belongs_to :checklist
  acts_as_taggable
end

