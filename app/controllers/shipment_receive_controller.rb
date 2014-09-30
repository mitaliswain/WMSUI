require 'json'
class ShipmentReceiveController < ApplicationController
 
  def index
    render text: 'ok'
   end
   
  def new 
    @shipment =   [
                  {"name" => 'shipment_nbr',  "description"=> "Shipment" ,  "value" => '', "validated" => false, "to_validate" => true},
                  {"name" => 'location',  "description"=> "Location" ,  "value" => '', "validated" => false, "to_validate" => true},
                  {"name" => 'case',      "description"=> "Case", "value" => '', "validated" => false, "to_validate" => true},
                  {"name" => 'item',      "description"=> "Item" , "value" => '', "validated" => false, "to_validate" => true},
                  {"name" => 'quantity',  "description"=> "Quantity",  "value" => '', "validated" => false, "to_validate" => true},
                  {"name" => 'inner_pack',"description"=> "Inner Pack",   "value" => '', "validated" => false ,"to_validate" => false }
                  ] 
    session[:wms].each do |wms|
      @shipment << wms
    end                           
    session[:shipment] = @shipment  
      @error = ''            
  end 
  
  def create    

    @shipment = session[:shipment]
    processed_response = ShipmentReceive.new.process_receiving(@shipment, params["name"], params["value"])
    session[:shipment] = processed_response[:shipment]
              
    if processed_response[:status] == '201'  
       redirect_to action: :new      
    else 
       @error =  processed_response[:error] 
       render 'new.html.erb'
    end

    end

 end  

