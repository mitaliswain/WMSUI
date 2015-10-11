class LoginController < ApplicationController

  skip_before_action :require_login, only: [:index, :new, :create]

  def index
  end
  
  def show 
  end
  
  def new
  end

  def create
     response = Login.new.login(params[:client], params[:userid], params[:password])
     render :json => response, status: response['status']
  end

  end

