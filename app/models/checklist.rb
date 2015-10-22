class Checklist < ActiveRecord::Base


  def check_today
    d = Date.today
    wday = ['月','火','水','木','金','土','日']
    today = d.day
    thiswday = wday[d.wday - 1]

    if self.frequency == '毎日' || self.frequency == '曜日指定' && self.days == thiswday || self.frequency == '日指定' && self.date == today
      self.todayflag = 1
    else
      self.todayflag = 0
    end
    self.save
  end

  def check_status
    if todayflag == 1
      if done == false
        return 'not_done.gif'
      elsif done == true
        return 'done.gif'
      else
      end
    elsif todayflag == 0
      return 'dont_have_to.gif'
    end
  end

  def deside_id
    if todayflag == 1
      if done == false
        return 'not_done'
      elsif done == true
        return 'done'
      else
      end
    elsif todayflag == 0
      return 'dont_have_to'
    end
  end

end
