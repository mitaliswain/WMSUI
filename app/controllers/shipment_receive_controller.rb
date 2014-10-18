require 'json'
class ShipmentReceiveController < ApplicationController
 
  def index
    render text: 'ok'
   end
   
  def new 
    shipment =   [
                  {"name" => 'shipment_nbr',  "description"=> "Shipment" ,  "value" => '', "validated" => false, "to_validate" => "Yes"},
                  {"name" => 'purchase_order_nbr',  "description"=> "Purchase Order" ,  "value" => '', "validated" => false, "to_validate" => "Yes"},
                  {"name" => 'location',  "description"=> "Location" ,  "value" => '', "validated" => false, "to_validate" => "Yes"},
                  {"name" => 'item',      "description"=> "Item" , "value" => '', "validated" => false, "to_validate" => "Yes"},
                  {"name" => 'case',      "description"=> "Case", "value" => '', "validated" => false, "to_validate" => "Yes"},
                  {"name" => 'quantity',  "description"=> "Quantity",  "value" => '', "validated" => false, "to_validate" => "Yes"},
                  {"name" => 'inner_pack',"description"=> "Inner Pack",   "value" => '', "validated" => false ,"to_validate" => "Yes" }
                ]
    @shipment = ShipmentReceive.new.prepare_shipment_receiving_screen(shipment) 
    @basic_parameters = session[:basic_parameters]        
    session[:shipment] = @shipment  
      @error = ''            
  end 
  
  def create    
    @basic_parameters = session[:basic_parameters]   
    @shipment = session[:shipment]
    processed_response = ShipmentReceive.new.process_receiving(@basic_parameters, @shipment, params["name"], params["value"])

    session[:shipment] = processed_response[:shipment]     
    @error =   processed_response[:error]          
    render 'new.html.erb'     

    end

 end  

