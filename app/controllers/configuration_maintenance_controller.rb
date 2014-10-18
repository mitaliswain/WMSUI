class ConfigurationMaintenanceController < ApplicationController

def index
  respond_to do |format|
      format.html 
      format.json { render :json => GlobalConfiguration.new.configuration_list(module: 'RECEIVING') }
    end
end

end