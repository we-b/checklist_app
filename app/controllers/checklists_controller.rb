class ChecklistsController < ApplicationController

  def index
    @checklists = Checklist.all.order(done: :ASC).page(params[:page])
    Checklist.check_all_checklists(@checklists)
    flash[:alert] = '本日未チェックのチェックリストがあります。' if Checklist.check_flash(@checklists)
  end

  def new
    @checklist_new = Checklist.new
    @contents = @checklist_new.contents.build
    @frequency = Checklist.get_frequency_list
    @wday = Checklist.get_wday_list
  end

  def show
    @checklist = Checklist.find(params[:id])
    @contents = @checklist.contents
    flash.now[:"#{@checklist.decide_flash_key}"] = "#{@checklist.decide_flash_message}"
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

  def create_checklist(params)
    if params[:frequency] == 'everyday'
      Checklist.petern_everyday(params)
    elsif params[:frequency] == 'wday'
      Checklist.petern_day(params)
    else
      Checklist.petern_wday(params)
    end
  end

  def create_list_contents(checklist, elements)
    elements.each { |ele| checklist.contents.create(text: ele[:text]) }
  end

end
