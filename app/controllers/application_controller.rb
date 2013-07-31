class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  check_authorization
  skip_authorization_check

  # TODO: remove hack to make CanCan work with Rails 4
  before_filter do
    resource = controller_path.singularize.gsub('/', '_').to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end

  def main
  end

  # TODO: change what happens when someone tries to do something where permission is denied
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: 'Permission Denied.'
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    redirect_to root_url, alert: 'Information cannot be found.'
  end

end
