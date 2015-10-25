class Checklist < ActiveRecord::Base

  enum frequency: { everyday: 0, wday:1, date:2 }
  enum wday:      { 日:0, 月:1, 火:2, 水:3, 木:4, 金:6, 土:7 }
  enum todayflag: { not_today: 0, today: 1 }


  def check_today
    d = Date.today
    wday = ['月','火','水','木','金','土','日']
    today = d.day
    thiswday = wday[d.wday - 1]
      if everyday? || wday?(thiswday) || date?(today)
        self.todayflag = 'today'
      else
        self.todayflag = 'not_today'
      end
      save
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
