class SessionsController < ApplicationController
  before_action :check_if_logged_in

  def new
    render :new
  end

  def create
    user = User.find_by_credentials(params[:user][:user_name], params[:user][:password])
    if user.nil?
      render :new
    else
      user.reset_session_token!
      session[:token] = user.session_token
      redirect_to cats_url
    end
  end

  def destroy
    if logged_in?
      current_user.reset_session_token!
      session[:token] = nil
    end
    redirect_to cats_url
  end

end
