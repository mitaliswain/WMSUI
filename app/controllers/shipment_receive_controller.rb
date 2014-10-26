require 'json'
class ShipmentReceiveController < ApplicationController
 
  def index
    redirect_to :action => 'new'
   end
   
  def new 
    shipment =   [
                  {"name" => 'location',  "description"=> "Location" ,  "value" => '', "validated" => false, "to_validate" => "Yes"},
                  {"name" => 'shipment_nbr',  "description"=> "Shipment" ,  "value" => '', "validated" => false, "to_validate" => "Yes"},
                  {"name" => 'purchase_order_nbr',  "description"=> "Purchase Order" ,  "value" => '', "validated" => false, "to_validate" => "Yes"},
                  {"name" => 'case',      "description"=> "Case", "value" => '', "validated" => false, "to_validate" => "Yes"},
                  {"name" => 'item',      "description"=> "Item" , "value" => '', "validated" => false, "to_validate" => "Yes"},
                  {"name" => 'quantity',  "description"=> "Quantity",  "value" => '', "validated" => false, "to_validate" => "Yes"},
                  {"name" => 'inner_pack',"description"=> "Inner Pack",   "value" => '', "validated" => false ,"to_validate" => "Yes" }
                ]
    @basic_parameters = session[:basic_parameters]        
    @shipment = ShipmentReceive.new(shipment, @basic_parameters).prepare_shipment_receiving_screen
    session[:shipment] = @shipment  
      @error = ''            
  end 
  
  def create    
    @basic_parameters = session[:basic_parameters]   
    @shipment = session[:shipment]
    processed_response = ShipmentReceive.new(@shipment, @basic_parameters).process_receiving(params["name"], params["value"])
    session[:shipment] = processed_response[:shipment]     
    @error =   processed_response[:error]          
    render 'new.html.erb'     

    end

 end  

