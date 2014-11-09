class CaseMaintenanceController < ApplicationController

  def index
    case_data = {}
    case_data['shipment_nbr'] = params[:id]
    case_data['warehouse'] = params[:warehouse]
    case_['client'] = params[:client]


    respond_to do |format|
      format.html
      format.json { render :json => CaseMaintenance.case_list(shipment) }
    end
  end

end