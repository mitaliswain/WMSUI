class ConfigurationMaintenanceController < ApplicationController

def index
  respond_to do |format|
      format.html 
      format.json { render :json => GlobalConfiguration.configuration_list }
    end
end

end