class ConfigurationMaintenanceController < ApplicationController

def index
  respond_to do |format|
      format.html 
      format.json { render :json => GlobalConfiguration.new(request.headers['authorization']).configuration_list(module: 'RECEIVING') }
    end
end


def show
  configuration = {}
  configuration['configuration_id'] = params[:id]
  configuration['warehouse'] = params[:warehouse]
  configuration['client'] = params[:client]

  respond_to do |format|
    format.html # show.html.erb
    format.json { render :json => GlobalConfiguration.new(request.headers['authorization']).configuration_details(configuration) }
  end
end

def update
  response = GlobalConfiguration.new(request.headers['authorization']).configuration_update(params[:id], params[:app_parameters], params[:fields_to_update])
  render :json => response, status: response['status']
end

end