class Checklist < ActiveRecord::Base

  enum frequency: [ :everyday, :wday, :date ]
  enum wday:      [ :sunday, :monday, :tueday, :wedday, :thuday, :friday, :satday ]
  enum todayflag: [ :not_today, :today ]

  paginates_per 3


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

end
