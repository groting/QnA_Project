require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery with: :exception
  before_action :gon_current_user

  private

  def gon_current_user
    gon.current_user_id = current_user.id if current_user
  end
end
