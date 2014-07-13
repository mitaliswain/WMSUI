require 'json'
class ShipmentReceiveController < ApplicationController
 
  def index
    render text: 'ok'
   end
   
  def new
    @response = Hash.new  
    @receiving = [
                  {"name" => 'location',  "description"=> "Location" ,  "value" => '', "validated" => false, "to_validate" => true},
                  {"name" => 'shipment_nbr',  "description"=> "Shipment" ,  "value" => '', "validated" => false, "to_validate" => true},
                  {"name" => 'case',      "description"=> "Case", "value" => '', "validated" => false, "to_validate" => true},
                  {"name" => 'item',      "description"=> "Item" , "value" => '', "validated" => false, "to_validate" => true},
                  {"name" => 'quantity',  "description"=> "Quantity",  "value" => '', "validated" => false, "to_validate" => true},
                  {"name" => 'inner_pack',"description"=> "Inner Pack",   "value" => '', "validated" => false ,"to_validate" => false }

                  ]               
    @sequence = 0
    session[:receiving] = @receiving           
    session[:sequence] = @sequence
    
    @response= {"status"=> true, "message"=> []}
  end 
  
  def create
    @response= {"status"=> true, "message"=> []}
     
    @wms = session[:wms]  
    @receiving = session[:receiving]
    @sequence =  session[:sequence]
    
    shipment = {}

    @wms.each_with_index do |receive, index|
      shipment.store(receive["name"], receive["value"])
    end
    
    @receiving.each_with_index do |receive, index|
      shipment.store(receive["name"], receive["value"]) if index < @sequence
      shipment.store(receive["name"], params[:name]) if index == @sequence  
    end
   
    
   if @receiving[@sequence]["to_validate"] 
       @response = Shipment.validate(@receiving[@sequence]["name"], shipment) 
   else
       @response = {"status"  => true, "message" => []}
   end      
                                            
    if @response["status"] == true
        @receiving[@sequence]["value"] = params[:name] if !params[:name].nil?
        @receiving[@sequence]["validated"] = true   
        @sequence = session[:sequence] + 1
    end    

    
    if @receiving[@sequence].nil? 
          @response = Shipment.receive(shipment)
          if @response["status"] == true
             session.delete('receiving')
             session.delete('sequence')
             redirect_to action: :new
          else
            puts @response   
          end
    else      
         session[:receiving] = @receiving 
         session[:sequence] =  @sequence    
         render 'new.html.erb' 
    end
       
  end
  
end

