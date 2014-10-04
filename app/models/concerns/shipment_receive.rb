require 'rest_client'

class ShipmentReceive
  
  def initialize
  end

  def process_receiving(basic_parameters, shipment, to_validate, value)
     
    shipment = set_shipment_value_from_input(shipment.clone, to_validate, "value", value)
    response = validate(basic_parameters, to_validate, shipment)
    if response["status"] == '200'            
      shipment = set_shipment_value_from_input(shipment.clone, to_validate, "validated", true)
    else  
      shipment = set_shipment_value_from_input(shipment.clone, to_validate, "value", "")
    end   
    if  response["status"] == '200' && !any_more_to_validate?(shipment.clone)
      response = receive(basic_parameters, shipment.clone)
      shipment = reset_shipment(shipment.clone)  if response["status"] == "201"
      p shipment
    end
    
    return {shipment: shipment, status: response["status"], error: get_error_message(response)}
  end
  
  def reset_shipment(shipment)
      items_not_to_be_reset = ["shipment_nbr", "location"]
      shipment_clone = shipment.clone
      shipment_clone.each_with_index do |shipment_item, index|
        if items_not_to_be_reset.select{|item| item == shipment_item["name"]}.empty?
            shipment_clone[index]["value"] = ""
            shipment_clone[index]["validated"] = false           
        end 
      end
      shipment_clone
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
  
 def any_more_to_validate?(shipment)
   shipment.each do |shipment_compoment|
     if shipment_compoment["validated"] == false
       return true  
     end
   end
     false 
 end
 
 def set_shipment_value_from_input(shipment, shipment_element, property, value)
    shipment.each_with_index do |element, index| 
      if element["name"] == shipment_element
         shipment[index][property] = value
         break
      end
    end    
    shipment
  end

  def receive(basic_parameters, shipment_data)
    
    shipment = extract_shipment(shipment_data)
    url = Properties.getUrl + '/shipment/' + shipment["shipment_nbr"] + '/receive'
   
    shipment = {
        client:     basic_parameters["client"], 
        warehouse:  basic_parameters["warehouse"],
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
      when 201
        responses
     else
       message = responses.nil? ? {} : JSON.parse(responses)["message"]  
      {status: responses.code, message: message}.to_json
    end
    }    
   return JSON.parse(response)
      
  end
  
  def validate(basic_parameters, to_validate, shipment_data)
    
      shipment = extract_shipment(shipment_data)   
      url = Properties.getUrl + '/shipment/' + to_validate + '/validate'
      
      
     shipment = {
        client:     basic_parameters["client"], 
        warehouse:  basic_parameters["warehouse"],
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
  
  def extract_shipment shipment_data    
    shipment = {}
    shipment_data.each do |shipment_info|
      shipment[shipment_info["name"]] = shipment_info["value"]
    end
    shipment
    
  end


end