class ItemMasterMaintenanceController < ApplicationController

  def index
    respond_to do |format|
      format.html
      format.json { render :json => ItemMaster.new.item_list }
    end
  end
=begin
  def update
    response = GlobalConfiguration.new.configuration_update(params[:id], params[:app_parameters], params[:fields_to_update])
    render :json => response, status: response['status']
  end
=end

end

