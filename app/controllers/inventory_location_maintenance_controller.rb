class ItemMasterMaintenanceController < ApplicationController

  def index
    respond_to do |format|
      format.html
      format.json { render :json => InventoryLocation.new(request.headers['authorization']).inventory_location_list }
    end
  end

  def show
    inventory_location = {}
    inventory_location['item_id'] = params[:id]
    inventory_location['warehouse'] = params[:warehouse]
    inventory_location['client'] = params[:client]

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => InventoryLocation.new(request.headers['authorization']).inventory_location_details(inventory_location) }
    end
  end

  def update
    response =InventoryLocation.new(request.headers['authorization']).update_inventory_location(params[:id], params[:app_parameters], params[:fields_to_update])
    render :json => response, status: response['status']
  end

  def create
    response = InventoryLocation.new(request.headers['authorization']).add_inventory_location(params[:app_parameters], params[:fields_to_update])
    render :json => response, status: response['status']
  end

end

