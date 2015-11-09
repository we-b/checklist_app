class Checklist < ActiveRecord::Base

  enum frequency: [ :everyday, :wday, :date ]
  enum wday:      [ :sun, :mon, :tue, :wed, :thu, :fri, :sat ]
  enum todayflag: [ :not_today, :today ]

  has_many :contents, dependent: :destroy
  accepts_nested_attributes_for :contents
  mount_uploader :image, ImageUploader

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

  def self.get_frequency_list
    frequency = []
    frequency.push(Settings.frequency_everyday, Settings.frequency_wday, Settings.frequency_date)
  end

  def self.get_wday_list
    wday = []
    wday.push(Settings.wday_sun, Settings.wday_mon, Settings.wday_tue, Settings.wday_wed, Settings.wday_thu, Settings.wday_fri, Settings.wday_sat,)
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

  def self.petern_everyday(params)
     Checklist.create(name: params[:name], frequency: 'everyday', wday: 0, date: 0, maker: params[:maker], image: params[:image], done: false)
  end

  def self.petern_day(params)
      Checklist.create(name: params[:name], frequency: 'wday', wday: params[:wday], date: 0, maker: params[:maker], image: params[:image], done: false)
  end

  def self.petern_wday(params)
      Checklist.create(name: params[:name], frequency: 'date', wday: 0, date: params[:date], maker: params[:maker], image: params[:image], done: false)
  end

end
