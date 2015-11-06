class ChecklistsController < ApplicationController

  def index
    @checklists = Checklist.all.order(done: :ASC).page(params[:page])
    Checklist.check_all_checklists(@checklists)
    flash[:alert] = '本日未チェックのチェックリストがあります。' if Checklist.check_flash(@checklists)
  end

  def new
    @checklist_new = Checklist.new
    @contents = @checklist_new.contents.build
    @week_days = I18n.t 'date.abbr_day_names'
    @month_days = 1..31
    @array = []
  end

  def create
    @checklist = create_checklist(create_params)
    @checklist.check_today
    create_list_contents(@checklist, contents_params)
    @checklist.save ? (redirect_to root_path, success: 'チェックリストの作成が完了しました') : (redirect_to back,  warning: "チェックリストの作成に失敗しました")
  end

  private
  def create_params
    params.require(:checklist).permit(:name, :frequency, :date, :wday, :maker, :image, :done)
  end

  def contents_params
    params.require(:text).require(:content)
  end

end
