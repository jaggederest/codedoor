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
    render('loggedout') unless current_user.present?
  end

  def redirect_cannot_be_found
    redirect_to root_url, alert: 'Information cannot be found.'
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_cannot_be_found
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    redirect_cannot_be_found
  end

  def ensure_user_checked_terms
    redirect_cannot_be_found unless current_user.present? && current_user.checked_terms?
  end

end
