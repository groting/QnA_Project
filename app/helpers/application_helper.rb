module ApplicationHelper
  def cache_key(object)
    klass_name = object.class.name
    max_updated_at = klass_name.constantize.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "#{klass_name.underscore}/login-#{user_signed_in?}-#{max_updated_at}"
  end
end
