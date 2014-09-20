require 'rest_client'
class Shipment
  
   def self.shipment_list(shipment)    
    url = Shipment.geturl + "/shipment/#{shipment['shipment_nbr']}?client=#{shipment['client']}&warehouse=#{shipment['warehouse']}"   
    response = RestClient.get url    
    return JSON.parse(response)       
  end


  def self.shipment_details(shipment)
    url = Shipment.geturl + "/shipment/#{shipment['shipment_nbr']}?client=#{shipment['client']}&warehouse=#{shipment['warehouse']}"   
    response = RestClient.get url    
    return JSON.parse(response)       
  end
  
  def self.shipment_update_header(id, app_parameters, fields_to_update)
    
    url = Shipment.geturl + "/shipment/#{id}/update_header"   
    response = RestClient.post(url, 
    app_parameters: app_parameters,
    fields_to_update: fields_to_update) { | responses, request, result, &block |
      case responses.code
      when 200, 201, 422
        responses
     else
      {status: responses.code, message: [responses.description]}.to_json
    end
    }     
    return JSON.parse(response)  
  end

  def self.shipment_add_header(app_parameters, fields_to_update)
    url = Shipment.geturl + "/shipment/add_header"   
    response = RestClient.post(url, 
    app_parameters: app_parameters,
    fields_to_update: fields_to_update) { | responses, request, result, &block |
      case responses.code
      when 200, 201, 422
        responses
     else
      {status: responses.code, message: [responses.description]}.to_json
    end
    }    
    return JSON.parse(response)  
  end

  def self.shipment_add_detail(app_parameters, fields_to_update)
    url = Shipment.geturl + "/shipment/add_detail"   
    response = RestClient.post(url, 
    app_parameters: app_parameters,
    fields_to_update: fields_to_update) { | responses, request, result, &block |
      case responses.code
      when 200, 201, 422
        responses
     else
      {status: responses.code, message: [responses.description]}.to_json
    end
    }    
    return JSON.parse(response)  
  end


  def self.shipment_update_detail(id, app_parameters, fields_to_update)    
    url = Shipment.geturl + "/shipment/#{id}/update_detail"
    response = RestClient.post(url, 
    app_parameters: app_parameters,
    fields_to_update: fields_to_update) { | responses, request, result, &block |
      case responses.code
      when 200, 201, 422
        responses
     else
      {status: false, message: [responses.description]}.to_json
    end
    }          
    return JSON.parse(response)  
  end

  def self.receive(shipment)

    url = Shipment.geturl + '/shipment/' + shipment["shipment_nbr"] + '/receive'
   

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
    response = RestClient.post url,
    shipment: shipment
   return JSON.parse(response)
      
  end
  
  def self.validate(to_validate, shipment)
      
      url = Shipment.geturl + '/shipment/' + to_validate + '/validate'
      
      
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
    response = RestClient.post url,
    shipment: shipment

    puts response     
    return JSON.parse(response)
    
  end
  
  def self.geturl
    'http://wmsservice.herokuapp.com'
    #'http://localhost:3001'
  end
    
end