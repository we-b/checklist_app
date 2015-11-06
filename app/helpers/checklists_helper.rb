module ChecklistsHelper

  def show_image(checklist)
    checklist.image.blank? ? 'noimage.gif' : checklist.image
  end

  def check_new(checklist)
    now = Time.now
    create_at = checklist.created_at
    image_tag 'new.gif', size: "40x16" if now - create_at <= 86400
  end

end
