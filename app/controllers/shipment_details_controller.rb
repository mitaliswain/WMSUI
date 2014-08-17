class ShipmentDetailsController < ApplicationController
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
  
  def update
    response = Shipment.shipment_details_update(params[:shipment], params[:field_to_update])
    render :json => response
  end
end
