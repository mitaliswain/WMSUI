class CaseMaintenanceController < ApplicationController

  def index
    case_data = {}
    case_data['shipment_nbr'] = params[:id]
    case_data['warehouse'] = params[:warehouse]
    case_data['client'] = params[:client]


    respond_to do |format|
      format.html
      format.json { render :json => CaseMaintenance.case_list(case_data) }
    end
  end

  def show 
    case_data = {}
    case_data['shipment_nbr'] = params[:id]
    case_data['warehouse'] = params[:warehouse]
    case_data['client'] = params[:client]
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => CaseMaintenance.caset_details(case_data) }
    end
  end
  
  def new
    
  end
  
  def add_detail
    
  end
  
  def edit_detail
    case_data = {}
    case_data['shipment_nbr'] = params[:id]
    case_data['warehouse'] = params[:warehouse]
    case_data['client'] = params[:client]
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => CaseMaintenance.case_details(case_detail) }
    end
  end

  def save_detail
    response = CaseMaintenance.case_add_detail(params[:app_parameters], params[:fields_to_update])
    render :json => response, status: response['status']
  end

  def add_header
    response = CaseMaintenance.case_add_header(params[:app_parameters], params[:fields_to_update])
    render :json => response, status: response['status']
  end
  
  def update_header
    response = CaseMaintenance.case_update_header(params[:id], params[:app_parameters], params[:fields_to_update])
    render :json => response, status: response['status']
  end

  def update_detail
    response = CaseMaintenance.case_update_detail(params[:id], params[:app_parameters], params[:fields_to_update])
    render :json => response, status: response['status']
  end

end