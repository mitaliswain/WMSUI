class ShipmentMaintenanceController < ApplicationController
  def index
    shipment = {}  
    shipment['shipment_nbr'] = params[:id]
    shipment['warehouse'] = params[:warehouse]
    shipment['client'] = params[:client]
    

    respond_to do |format|
      format.html 
      format.json { render :json => Shipment.new(request.headers['authorization']).shipment_list(shipment) }
    end
  end
  
  def show 
    shipment = {}  
    shipment['shipment_nbr'] = params[:id]
    shipment['warehouse'] = params[:warehouse]
    shipment['client'] = params[:client]
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => Shipment.new(request.headers['authorization']).shipment_details(shipment, params[:expand]) }
    end
  end
  
  def new
    
  end

  
  def edit_detail
    shipment = {}  
    shipment['shipment_nbr'] = params[:id]
    shipment['warehouse'] = params[:warehouse]
    shipment['client'] = params[:client]
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => Shipment.new(request.headers['authorization']).shipment_details(shipment) }
    end
  end

  def add_header
    response = Shipment.new(request.headers['authorization']).shipment_add_header(params[:app_parameters], params[:fields_to_update])
    render :json => response, status: response['status']
  end


  def update_header
    response = Shipment.new(request.headers['authorization']).shipment_update_header(params[:id], params[:app_parameters], params[:fields_to_update])
    render :json => response, status: response['status']
  end

  def add_detail
    response = Shipment.new(request.headers['authorization']).shipment_add_detail(params[:app_parameters], params[:fields_to_update])
    render :json => response, status: response['status']
  end

  def update_detail
    response = Shipment.new(request.headers['authorization']).shipment_update_detail(params[:id], params[:app_parameters], params[:fields_to_update])
    render :json => response, status: response['status']
  end

end
