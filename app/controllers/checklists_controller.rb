class ChecklistsController < ApplicationController
  protect_from_forgery except: [:destroy]

  def index
    @checklists = Checklist.all.order(done: :ASC).page(params[:page])
    Checklist.check_all_checklists(@checklists)
    flash.now[:alert] = '本日未チェックのチェックリストがあります。' if Checklist.check_flash(@checklists)
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

  def edit
    @checklist = Checklist.find(params[:id])
    @frequency = Checklist.get_frequency_list
    @wday = Checklist.get_wday_list
  end

  def update
    @checklist = Checklist.find(params[:id])
    if params.require(:checkflag).to_i == 1
      @checklist.check_contents
      redirect_to :root, success: 'チェックが完了しました'
    else
      @checklist.update(create_params)
      @checklist.edit_contents(params, contents_params)
      redirect_to :root, success: 'チェックリストの編集が完了しました'
    end
  end

  def destroy
    @checklist = Checklist.find(params[:id])
    @checklist.destroy ? (flash.now[:success] = 'チェックリストの削除が完了しました') : (redirect_to back, warning: 'チェックリストを削除できませんでした')
  end

  def create
    @checklist = create_checklist(create_params)
    @checklist.check_today
    create_list_contents(@checklist, contents_params)
    @checklist.save ? (redirect_to root_path, success: 'チェックリストの作成が完了しました') : (redirect_to back,  warning: "チェックリストの作成に失敗しました")
  end


  def create_params
    params.require(:checklist).permit(:name, :frequency, :date, :wday, :maker, :image, :done)
  end

  def contents_params
    if params.require(:text).include?(:content)
      params.require(:text).require(:content)
    else
      [ { text: 'none' } ]
    end

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
