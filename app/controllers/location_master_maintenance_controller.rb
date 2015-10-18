class LocationMasterMaintenanceController < ApplicationController

protect_from_forgery except: :index

  def index
    respond_to do |format|
      format.html
      format.json { render :json => LocationMaster.new(request.headers['authorization']).location_list }
    end
  end

  def show
    location = {}
    location['location_id'] = params[:id]
    location['warehouse'] = params[:warehouse]
    location['client'] = params[:client]

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => LocationMaster.new(request.headers['authorization']).location_details(location) }
    end
  end

  def update
    response =LocationMaster.new(request.headers['authorization']).update_location_master(params[:id], params[:app_parameters], params[:fields_to_update])
    render :json => response, status: response['status']
  end

  def create
    response = LocationMaster.new(request.headers['authorization']).add_location_master(params[:app_parameters], params[:fields_to_update])
    render :json => response, status: response['status']
  end

end

