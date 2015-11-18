class Checklist < ActiveRecord::Base

  enum frequency: [ :everyday, :wday, :date ]
  enum wday:      [ :sun, :mon, :tue, :wed, :thu, :fri, :sat ]
  enum todayflag: [ :not_today, :today ]

  has_many :contents, dependent: :destroy
  accepts_nested_attributes_for :contents
  mount_uploader :image, Checklist_thumbnailUploader

  paginates_per 3
  default_scope { order(todayflag: :DESC) }

  def self.set_checklist(params)
    return Checklist.find(params[:id])
  end

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
      if checklist.deside_id == 'not_done' && checklist.todayflag == 'today'
        flag += 1
      end
     return judgement = flag != 0 ? true : false
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

  def check_contents
    self.done = true
    self.save
  end

  def self.create_checklist(params)
    if params[:frequency] == 'everyday'
      Checklist.petern_everyday(params)
    elsif params[:frequency] == 'wday'
      Checklist.petern_day(params)
    else
      Checklist.petern_wday(params)
    end
  end

  def edit_contents(params, new_contents_params)
    self.contents.each do |content|
      id = content.id.to_s
      binding.pry
      params[:text][id] ? content.update(text: params[:text][id][:text]) : content.destroy
    end
    new_contents_params.each { |new_text| self.contents.create(text: new_text[:text]) unless new_text[:text] == 'none' }
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
