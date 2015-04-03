class LoginController < ApplicationController

  skip_before_action :require_login, only: [:index, :new, :create]

  def index
  end
  
  def show 
  end
  
  def new
  end

  def create
    if params[:username] == 'Admin' && params[:password] == 'Admin'
      message = {status: '200', message: 'Valid Login'}
      session[:username] = params[:username]
    else
      message = {status: '422', message: 'Invalid User Id or Password'}
    end

    render json: message.to_json, status: message[:status]
  end

  end
