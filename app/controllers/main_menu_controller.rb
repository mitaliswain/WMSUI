class MainMenuController < ApplicationController
  def new
    
  end

  def create
    session[:wms] = [ { "name" => 'client', "description"=> "Client", "value" =>params[:client] },
                      { "name" => 'warehouse', "description"=> "Warehouse", "value" =>params[:warehouse] } ]    
    
    redirect_to '/shipmentreceive/new' 
  end
  
  
end
