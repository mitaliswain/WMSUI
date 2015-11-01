class LocationInventoryMaintenance < ApplicationController

  def index
    respond_to do |format|
      format.html
      format.json { render :json => LocationInventory.new(request.headers['authorization']).location_inventory_list }
    end
  end

  def show
    inventory_location = {}
    inventory_location['item_id'] = params[:id]
    inventory_location['warehouse'] = params[:warehouse]
    inventory_location['client'] = params[:client]

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => LocationInventory.new(request.headers['authorization']).location_inventory_details(location_inventory) }
    end
  end

  def update
    response =LocationInventory.new(request.headers['authorization']).update_location_inventory(params[:id], params[:app_parameters], params[:fields_to_update])
    render :json => response, status: response['status']
  end

  def create
    response = LocationInventory.new(request.headers['authorization']).add_location_inventory(params[:app_parameters], params[:fields_to_update])
    render :json => response, status: response['status']
  end

end

