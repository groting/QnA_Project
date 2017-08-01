require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery with: :exception
  before_action :gon_current_user

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to questions_path, alert: exception.message }
      format.json { render json: { error: exception.message.to_s }, status: :forbidden }
      format.js   { head :forbidden }
    end
  end

  check_authorization unless: :devise_controller?

  def self.render_with_serializer(user, *args)
    ActionController::Renderer::RACK_KEY_TRANSLATION['warden'] ||= 'warden'
    proxy = Warden::Proxy.new({}, Warden::Manager.new({})).tap{|i| i.set_user(user, scope: :user) }
    renderer = self.renderer.new('warden' => proxy)
    renderer.render(*args)
  end

  private

  def gon_current_user
    gon.current_user_id = current_user.id if current_user
  end
end
