class Api::V1::ProfilesController < Api::V1::BaseController
  authorize_resource class: User

  def index
    @profiles = User.where.not(id: current_resource_owner)
    respond_with @profiles
  end

  def me
    respond_with(current_resource_owner)
  end
end