class Api::ChecksController < ApplicationController

  def update
    @content = Content.find(params[:id])
    @content.checked = true
    @content.save
  end

  def destroy
    @content = Content.find(params[:id])
    @content.checked = false
    @content.save
  end

end
