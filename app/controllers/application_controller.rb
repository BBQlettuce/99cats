class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  helper_method :current_user, :logged_in?, :login!

  def current_user
    return nil if session[:token].nil?
    @current_user ||= User.find_by(session_token: session[:token])
  end

  def logged_in?
    !!current_user
  end

  def login!(user)
    @current_user = user
    session[:token] = user.session_token
  end
end
