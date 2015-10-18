class UserMasterMaintenanceController < ApplicationController

  def index
    respond_to do |format|
      format.html
      format.json { render :json => UserMaster.new(request.headers['authorization']).user_list }
    end
  end

  def show
    user = {}
    user['client'] = params[:client]
    user['id'] = params[:id]

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => UserMaster.new(request.headers['authorization']).user_details(user) }
    end
  end

  def update
    response =UserMaster.new(request.headers['authorization']).update_user_master(params[:id], params[:app_parameters], params[:fields_to_update])
    render :json => response, status: response['status']
  end

  def create
    response = UserMaster.new(request.headers['authorization']).add_user_master(params[:app_parameters], params[:fields_to_update])
    render :json => response, status: response['status']
  end

end