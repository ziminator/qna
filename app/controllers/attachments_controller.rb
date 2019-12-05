class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @attachment = ActiveStorage::Attachment.find(params[:id])
    if current_user.author?(@attachment.record)
      @attachment.purge
    else
      redirect_to @attachment.record
    end
  end
end
