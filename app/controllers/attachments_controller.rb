class AttachmentsController < ApplicationController
  respond_to :js

  load_and_authorize_resource

  def destroy
    respond_with(@attachment.destroy)
  end
end
