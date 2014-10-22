

class ConfigurationMaintenanceController < ApplicationController

def index
  respond_to do |format|
      format.html 
      format.json { render :json => GlobalConfiguration.new.configuration_list(module: 'RECEIVING') }
    end
end

def update
  response = GlobalConfiguration.new.configuration_update(params[:id], params[:app_parameters], params[:fields_to_update])
  render :json => response, status: response['status']
end

end