require 'rest_client'

class ShipmentReceive

  def process_receiving(shipment, to_validate, value)
     
    shipment = set_shipment_value_from_input(shipment, to_validate, "value", value)
    response = validate(to_validate, shipment)

    if response["status"] == '200'            
      shipment = set_shipment_value_from_input(shipment, to_validate, "validated", "true")
    else  
      shipment = set_shipment_value_from_input(shipment, to_validate, "value", "")
    end   

    if  response["status"] == '200' && !any_more_to_validate?(shipment)
      response = receive(shipment)
    end

          
    return {shipment: shipment, status: response["status"], error: get_error_message(response)}
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

  def receive(shipment_data)
    
    shipment = extract_shipment(shipment_data)
    url = Properties.getUrl + '/shipment/' + shipment["shipment_nbr"] + '/receive'
   
    shipment = {
        client:     shipment["client"], 
        warehouse:  shipment["warehouse"],
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
  
  def validate(to_validate, shipment_data)
    
      shipment = extract_shipment(shipment_data)   
      url = Properties.getUrl + '/shipment/' + to_validate + '/validate'
      
      
     shipment = {
        client:     shipment["client"], 
        warehouse:  shipment["warehouse"],
        channel:    nil,
        building:   nil,
        shipment_nbr:   shipment["shipment_nbr"],
        location:   shipment["location"],
        case_id:    shipment["case"],
        item:       shipment["item"],
        quantity:   shipment["quantity"],
        innerpack_qty:   shipment["inner_pack"]
       } 
    puts shipment   
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