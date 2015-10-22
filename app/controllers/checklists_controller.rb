class ChecklistsController < ApplicationController

  def index
    Checklist.all.each do|checklist|
      checklist.check_today
      flash.now[:alert] = '本日未チェックのチェックリストがあります。' if checklist.deside_id == 'not_done'
    end
    @checklists = Checklist.all.order('todayflag DESC').order('done ASC').page(params[:page]).per(3)
  end

end

