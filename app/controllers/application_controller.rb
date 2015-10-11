class ApplicationController < ActionController::Base

  before_action :require_login

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  #protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format.include? 'application/json' }

  private
  def require_login
    if request.headers['authorization'].nil?
      #redirect_to login_url
    end
  end
end
