class ChecklistsController < ApplicationController

  def index
    @checklists = Checklist.all.order(todayflag: :DESC).order(done: :ASC).page(params[:page])
    Checklist.check_all_checklists(@checklists)
    flash[:alert] = '本日未チェックのチェックリストがあります。' if Checklist.check_flash(@checklists)
  end
end
