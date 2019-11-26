class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_attachment, only: %i[destroy]

  def destroy
    if current_user.author?(find_attachment.record)
      @attachment.purge
    else
      redirect_to find_attachment.record
    end
  end

  private

  def find_attachment
    @attachment = ActiveStorage::Attachment.find(params[:id])
  end
end
