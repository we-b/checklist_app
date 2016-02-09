class Checklist < ActiveRecord::Base

  has_many :contents, dependent: :destroy
  accepts_nested_attributes_for :contents


  mount_uploader :image, Checklist_thumbnailUploader

  enum frequency: [ :everyday, :wday, :date ]
  enum wday:      [ :not_desided, :sun, :mon, :tue, :wed, :thu, :fri, :sat ]
  enum todayflag: [ :not_today, :today ]

  paginates_per 3
  default_scope { order(todayflag: :DESC) }

  def check_today
    today = Settings.d.day
    thiswday = Settings.wday[Settings.d.wday - 1]
    if everyday? || wday?(thiswday) || date?(today)
      self.todayflag = 'today'
    else
      self.todayflag = 'not_today'
    end
    save
  end

  def self.check_all_checklists(checklists)
     checklists.each { |checklist| checklist.check_today }
  end

  def self.check_flash(checklists)
    checklists.each do |checklist|
      flag = 0
      flag += 1 if checklist.deside_id == 'not_done'
      return true if flag != 0
    end
  end

  def decide_flash_message
    if todayflag == 'today'
      if done
        '本日チェック済みです。 お疲れ様でした'
      else
        '本日未チェックです！ チェックしましょう'
      end
    else
      '本日チェックする必要はございません'
    end
  end


  def decide_flash_key
    if todayflag == 'today'
      if done
        'success'
      else
        'danger'
      end
    else
      'info'
    end
  end



  def check_status
    if todayflag == 'today'
      if done
        'done.gif'
      else
        'not_done.gif'
      end
    elsif todayflag == 'not_today'
      'dont_have_to.gif'
    end
  end

  def deside_id
    if todayflag == 'today'
      if done
        'done'
      else
        'not_done'
      end
    elsif todayflag == 'not_today'
      'dont_have_to'
    end
  end

  def everyday?
    frequency == 'everyday' ? true : false
  end

  def wday?(thiswday)
    frequency == 'wday' && wday == thiswday ? true : false
  end

  def date?(today)
    frequency == 'date' && date == today ? true : false
  end

  def self.create_tags(contents, all_tags)
    contents.each.with_index { |content, i| content.tag_list.add(all_tags[i]) }
  end

end
