class Content < ActiveRecord::Base

  belongs_to :checklist
  acts_as_taggable


  def check_status
    checked ? true : false
  end

end

