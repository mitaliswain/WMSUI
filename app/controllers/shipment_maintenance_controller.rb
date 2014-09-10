class ShipmentMaintenanceController < ApplicationController
  def index
    shipment = {}  
    shipment['shipment_nbr'] = params[:id]
    shipment['warehouse'] = params[:warehouse]
    shipment['client'] = params[:client]

    respond_to do |format|
      format.html 
      format.json { render :json => Shipment.shipment_list(shipment) }
    end
  end
  
  def show 
    shipment = {}  
    shipment['shipment_nbr'] = params[:id]
    shipment['warehouse'] = params[:warehouse]
    shipment['client'] = params[:client]
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => Shipment.shipment_details(shipment) }
    end
  end
  
  def new
    
  end

  def add_header
    response = Shipment.shipment_add_header(params[:app_parameters], params[:fields_to_update])
    render :json => response
  end
  
  def update_header
    response = Shipment.shipment_update_header(params[:id], params[:app_parameters], params[:fields_to_update])
    render :json => response
  end

  def update_detail
    response = Shipment.shipment_update_detail(params[:id], params[:shipment], params[:fields_to_update])
    render :json => response
  end

end
