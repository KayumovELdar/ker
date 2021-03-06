class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  before_action :file, only: %i[destroy]
  authorize_resource

  def destroy
    @file.purge if current_user.author?(@file.record)
  end

  private

  def file
    @file ||= ActiveStorage::Attachment.find(params[:file])
  end
end
