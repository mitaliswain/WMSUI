require 'json'
class ShipmentReceiveController < ApplicationController
 
  def index
    render text: 'ok'
   end
   
  def new
    @response = Hash.new  
    @receiving = [{"name" => 'client',    "description"=> "Client",  "value" => 'WM', "validated" => true},
                  {"name" => 'warehouse', "description"=> "Warehouse", "value" => 'WH1', "validated" => true}, 
                  {"name" => 'building',  "description"=> "Building", "value" => '', "validated" => false}, 
                  {"name" => 'channel',   "description"=> "Channel",  "value" => '', "validated" => false},
                  {"name" => 'shipment_nbr',  "description"=> "Shipment" ,  "value" => '', "validated" => false},
                  {"name" => 'location',  "description"=> "Location" ,  "value" => '', "validated" => false},
                  {"name" => 'case',      "description"=> "Case", "value" => '', "validated" => false},
                  {"name" => 'item',      "description"=> "Item" , "value" => '', "validated" => false},
                  {"name" => 'quantity',  "description"=> "Quantity",  "value" => '', "validated" => false},
                  {"name" => 'inner_pack',"description"=> "Inner Pack",   "value" => '', "validated" => false}

                  ]               
    @sequence = 0
    session[:receiving] = @receiving           
    session[:sequence] = @sequence
    
    @response= {"valid"=> true, "error"=> [""]}
  end 
  
  def create
    @response= {"valid"=> true, "error"=> [""]}
     
    @receiving = session[:receiving]
    @sequence =  session[:sequence]
    
    shipment = {}
    
    @receiving.each_with_index do |receive, index|
      shipment.store(receive["name"], receive["value"]) if index < @sequence
      shipment.store(receive["name"], params[:name]) if index == @sequence  
    end
    
    
    @response = Shipment.validate(@receiving[@sequence]["name"], shipment)
                                            
    if @response["valid"] == true
        @receiving[@sequence]["value"] = params[:name] if !params[:name].nil?
        @receiving[@sequence]["validated"] = true   
        @sequence = session[:sequence] + 1
    end    

    
    if @receiving[@sequence].nil? 
          @response = Shipment.receive(shipment)
          if @response["valid"] == true
             session.delete('receiving')
             session.delete('sequence')
             redirect_to action: :new
          end
    else      
         session[:receiving] = @receiving 
         session[:sequence] =  @sequence    
         render 'new.html.erb' 
    end
       
  end
  
end

