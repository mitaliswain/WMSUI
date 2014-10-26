require 'rest_client'

class ShipmentReceive
  attr_accessor :shipment, :basic_parameters, :config_list
  
  def initialize(shipment, basic_parameters)
    @shipment=shipment
    @basic_parameters = basic_parameters
    @config_list = GlobalConfiguration.new.configuration_list_key_value(module: 'RECEIVING')
  end

  def prepare_shipment_receiving_screen
    prepare_for_case_receiving if self.config_list[:Receiving_Type] == 'Case'
    prepare_for_sku_receiving if self.config_list[:Receiving_Type] == 'SKU'  
    self.shipment
  end
  
  def process_receiving(to_validate, value)
    response = any_more_to_validate? ?  validate_shipment_and_reset_the_input(to_validate, value) : receive_shipment_and_reset_the_input  
    return {shipment: self.shipment, status: response["status"], error: get_error_message(response)}
  end

private

  def validate_shipment_and_reset_the_input(to_validate, value)
      set_shipment_value_from_input(to_validate, "value", value)
      response = validate_shipment(to_validate)
      
      response["status"] == '200'  ?         
         set_shipment_value_from_input(to_validate, "validated", true) : set_shipment_value_from_input(to_validate, "value", "")             
      set_case_details(response["additional_info"][0])  if case_successfully_validated?(to_validate, response)   
      #response = receive_shipment_and_reset_the_input   if all_validation_completed_successfully?(response)  
      
      response      
  end
  
  def case_successfully_validated?(to_validate, response)
    response["status"] == '200' && self.config_list[:Receiving_Type] == 'Case' && to_validate == "case" 
  end

  def set_case_details(case_detail)    
    set_shipment_value_from_input("item", "value", case_detail["item"])
    set_shipment_value_from_input("item", "to_validate", 'Yes')
    set_shipment_value_from_input("item", "validated", true)
            
    set_shipment_value_from_input("quantity", "value", case_detail["quantity"])
    set_shipment_value_from_input("quantity", "to_validate", 'Yes')
    set_shipment_value_from_input("quantity", "validated", true)
  end
  
  def prepare_for_sku_receiving
    index = self.shipment.find_index {|field| field["name"] == "purchase_order_nbr"}
    self.shipment[index]["to_validate"] = self.config_list[:Purchase_Order_Required] if index && self.config_list.has_key?(:Purchase_Order_Required)
  end
  
  def prepare_for_case_receiving
    ["purchase_order_nbr", "item", "quantity", "inner_pack"].each do |item|
      index = shipment.find_index {|field| field["name"] == item}
      self.shipment[index]["to_validate"] = 'No' if index 
    end
  end
  
  def receive_shipment_and_reset_the_input 
      response = receive_shipment     
      reset_shipment if response["status"] == "201"
      response
  end
  
  def all_validation_completed_successfully?(response)
    response["status"] == '200' && !any_more_to_validate?
  end  
  
  def reset_shipment
      items_not_to_be_reset = ["shipment_nbr", "location"]
      self.shipment.each_with_index do |shipment_item, index|
        if items_not_to_be_reset.select{|item| item == shipment_item["name"]}.empty?
            self.shipment[index]["value"] = ""
            self.shipment[index]["validated"] = false           
        end 
      end
  end
   
  def get_error_message(response)
    
    case response["status"]
    when "200"
      ""
    when "201", "415"
      response["message"] 
    when "422"
      response["errors"][0]["message"] 
    else
       "Error in processing"       
    end  
    
  end 
  
 def any_more_to_validate?
   self.shipment.each do |shipment_compoment|
     if shipment_compoment["validated"] == false && shipment_compoment["to_validate"] == 'Yes' 
       return true  
     end
   end
     false 
 end
 
 def set_shipment_value_from_input(shipment_element, property, value)
    self.shipment.each_with_index do |element, index| 
      if element["name"] == shipment_element
         self.shipment[index][property] = value
         break
      end
    end    
    shipment
  end

  def receive_shipment
    
    shipment = extract_shipment
    url = Properties.getUrl + '/shipment/' + shipment["shipment_nbr"] + '/receive'
   
    shipment = {
        client:     self.basic_parameters["client"], 
        warehouse:  self.basic_parameters["warehouse"],
        channel:    nil,
        building:   nil,
        shipment_nbr:   shipment["shipment_nbr"],
        location:   shipment["location"],
        case_id:    shipment["case"],
        item:       shipment["item"],
        quantity:   shipment["quantity"],
        innerpack_qty:   shipment["inner_pack"]
       } 
    response = RestClient.post(url,
    shipment: shipment){ | responses, request, result, &block |
      case responses.code
      when 200, 201, 422, 204
        responses
     else
       message = responses.nil? ? {} : JSON.parse(responses)["message"]  
      {status: responses.code, message: message}.to_json
    end
    }    

   return JSON.parse(response)
      
  end
  
  def validate_shipment(to_validate)
    
      shipment = extract_shipment  
      url = Properties.getUrl + '/shipment/' + to_validate + '/validate'
      
      
     shipment = {
        client:     self.basic_parameters["client"], 
        warehouse:  self.basic_parameters["warehouse"],
        channel:    nil,
        building:   nil,
        shipment_nbr:   shipment["shipment_nbr"],
        location:   shipment["location"],
        case_id:    shipment["case"],
        item:       shipment["item"],
        quantity:   shipment["quantity"],
        innerpack_qty:   shipment["inner_pack"]
       } 
    response = RestClient.post(url,
    shipment: shipment) { | responses, request, result, &block |
      case responses.code
      when 200, 201, 422, 204
        responses
     else
       message = responses.nil? ? {} : JSON.parse(responses)["message"]  
      {status: responses.code, message: message}.to_json
    end
    }    
    return JSON.parse(response)    
  end
  
  
  def extract_shipment
    shipment = {}
    self.shipment.each do |shipment_info|
      shipment[shipment_info["name"]] = shipment_info["value"]
    end
    shipment
    
  end
  
end