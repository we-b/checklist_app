class Checklist < ActiveRecord::Base

  enum frequency: [ :everyday, :wday, :date ]
  enum wday:      [ :not_desided, :sun, :mon, :tue, :wed, :thu, :fri, :sat ]
  enum todayflag: [ :not_today, :today ]

  has_many :contents, dependent: :destroy
  accepts_nested_attributes_for :contents
  mount_uploader :image, Checklist_thumbnailUploader

  paginates_per 3
  default_scope { order(todayflag: :DESC) }


  def check_today
    today = Date.today
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
    judge_flag = false
    checklists.each do |checklist|
      judge_flag = checklist.done == false && checklist.todayflag == 'today'
    end
    return judge_flag

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

  def edit_contents(params, new_contents_params)
    self.contents.each do |content|
      id = content.id.to_s
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

end
