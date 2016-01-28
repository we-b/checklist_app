class Group < ActiveRecord::Base

  belongs_to :checklist
  has_many :contents

end
