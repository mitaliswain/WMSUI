class UserMasterMaintenanceController < ApplicationController

  def index
    respond_to do |format|
      format.html
      format.json { render :json => UserMaster.new.user_list }
    end
  end

  def show
    user = {}
    user['client'] = params[:client]

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => UserMaster.user_details(user) }
    end
  end

  def update
    response =UserMaster.new.update_user_master(params[:id], params[:app_parameters], params[:fields_to_update])
    render :json => response, status: response['status']
  end

  def create
    response = UserMaster.add_user_master(params[:app_parameters], params[:fields_to_update])
    render :json => response, status: response['status']
  end

end