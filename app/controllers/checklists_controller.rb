class ChecklistsController < ApplicationController
  protect_from_forgery except: [:destroy]
  before_action :set_checklist, only: [:edit, :update, :destroy, :show]

  def index
    @checklists = Checklist.all.order(done: :ASC).page(params[:page])
    Checklist.check_all_checklists(@checklists)
    flash.now[:alert] = '本日未チェックのチェックリストがあります。' if Checklist.check_flash(@checklists)
  end

  def new
    @checklist = Checklist.new
    @contents = @checklist.contents.build
  end

  def show
    @contents = @checklist.contents
    flash.now[:"#{@checklist.decide_flash_key}"] = "#{@checklist.decide_flash_message}"
  end

  def update
    if params.require(:checkflag).to_s == 'edit_checklist'
      @checklist.check_contents
      redirect_to :root, success: 'チェックが完了しました'
    else
      @checklist.update(checklist_params)
      @checklist.edit_contents(params, contents_params)
      redirect_to :root, success: 'チェックリストの編集が完了しました'
    end
  end

  def destroy
    @checklist.destroy ? (flash.now[:success] = 'チェックリストの削除が完了しました') : (redirect_to back, warning: 'チェックリストを削除できませんでした')
  end

  def create
    @checklist = Checklist.create_checklist(checklist_params)
    @checklist.check_today
    create_list_contents(@checklist, contents_params)
    @checklist.save ? (redirect_to root_path, success: 'チェックリストの作成が完了しました') : (redirect_to back,  warning: "チェックリストの作成に失敗しました")
  end

  private


  def checklist_params
    params.require(:checklist).permit(:name, :frequency, :date, :wday, :maker, :image, :done)
  end

  def contents_params
    if params.require(:text).include?(:content)
      params.require(:text).require(:content)
    else
      [ { text: 'none' } ]
    end
  end

  def create_list_contents(checklist, elements)
    elements.each { |ele| checklist.contents.create(text: ele[:text]) }
  end

   def set_checklist
    @checklist = Checklist.find(params[:id])
  end


end
