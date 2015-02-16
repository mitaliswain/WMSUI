class ItemMasterMaintenanceController < ApplicationController

  def index
    respond_to do |format|
      format.html
      format.json { render :json => ItemMaster.new.item_list }
    end
  end

  def show
    item = {}
    item['item_id'] = params[:id]
    item['warehouse'] = params[:warehouse]
    item['client'] = params[:client]

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => ItemMaster.item_details(item) }
    end
  end

  def update
    response =ItemMaster.new.update_item_master(params[:id], params[:app_parameters], params[:fields_to_update])
    render :json => response, status: response['status']
  end


end

