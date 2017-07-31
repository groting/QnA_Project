class Api::V1::ProfilesController < ApplicationController
  before_action :doorkeeper_authorize!

  respond_to :json

  authorize_resource class: User

  def others
    @profiles = User.where.not(id: current_resource_owner)
    respond_with @profiles
  end

  def me
    respond_with(current_resource_owner)
  end

  private

  def current_resource_owner
    @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  def current_ability
    @ability ||= Ability.new(current_resource_owner)
  end
end