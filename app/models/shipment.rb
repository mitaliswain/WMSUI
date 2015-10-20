require 'rest_client'

class Shipment
  
  def initialize(token)
    @token = token
  end
  
  def shipment_list(shipment)    
    url = Properties.getUrl + "/shipment/?client=#{shipment['client']}&warehouse=#{shipment['warehouse']}"
    response = RestClient.get url, {authorization: @token}   
    return JSON.parse(response)       
  end


  def shipment_details(shipment)
    url = Properties.getUrl + "/shipment/#{shipment['shipment_nbr']}?client=#{shipment['client']}&warehouse=#{shipment['warehouse']}"   
    response = RestClient.get url, {authorization: @token}    
    return JSON.parse(response)       
  end
  
  def shipment_update_header(id, app_parameters, fields_to_update)
    
    url = Properties.getUrl + "/shipment/#{id}/update_header"   
    response = RestClient.post(url, 
    app_parameters: app_parameters,
    fields_to_update: fields_to_update,
    authorization: @token ) { | responses, request, result, &block |
      case responses.code

      when 200, 201, 422,204
        responses
     else
       message = responses.nil? ? {} : JSON.parse(responses)["message"]
      {status: responses.code, message: message}.to_json
    end
    }    
    return JSON.parse(response)  
  end

  def shipment_add_header(app_parameters, fields_to_update)
    url = Properties.getUrl + "/shipment/add_header"   
    response = RestClient.post(url, 
    app_parameters: app_parameters,
    fields_to_update: fields_to_update,
    authorization: @token) { | responses, request, result, &block |
      case responses.code
      when 200, 422
        responses
      when 201  
        message = JSON.parse(responses)  
        resource_url = Properties.getUrl + message["content"][0]["link"]
        response = RestClient.get(resource_url, {authorization: @token})
        return JSON.parse(response)    
     else
      message = responses.nil? ? {} : JSON.parse(responses)["message"] 
      {status: responses.code, message: [message]}.to_json
    end
    }     
    return JSON.parse(response)  
  end


  def shipment_add_detail(app_parameters, fields_to_update)
    url = Properties.getUrl + "/shipment/add_detail"   
    response = RestClient.post(url, 
    app_parameters: app_parameters,
    fields_to_update: fields_to_update,
    authorization: @token) { | responses, request, result, &block |
      case responses.code
      when 200, 422, 204
        responses
      when 201
        message = JSON.parse(responses)
        p message
        resource_url = Properties.getUrl + message["content"][0]["link"]
        response = RestClient.get(resource_url, {authorization: @token})
        return JSON.parse(response)
      else
       message = responses.nil? ? {} : JSON.parse(responses)["message"]  
      {status: responses.code, message: message}.to_json
    end
    }    
    return JSON.parse(response)  
  end


  def shipment_update_detail(id, app_parameters, fields_to_update)    
    url = Properties.getUrl + "/shipment/#{id}/update_detail"
    response = RestClient.post(url, 
    app_parameters: app_parameters,
    fields_to_update: fields_to_update,
    authorization: @token) { | responses, request, result, &block |
      case responses.code
      when 200, 201, 422
        responses
      when 204  
        {status: responses.code, message: []}.to_json  
     else
       message = responses.nil? ? {} : JSON.parse(responses)["message"]  
      {status: responses.code, message: message}.to_json
    end
    }          
    return JSON.parse(response)  
  end

end