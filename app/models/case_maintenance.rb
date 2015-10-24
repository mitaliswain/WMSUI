require 'rest_client'

class CaseMaintenance

  def initialize(token)
    @token = token
  end
    
  def case_list(case_data)
    url = Properties.getUrl + "/case/#{case_data['case']}?client=#{case_data['client']}&warehouse=#{case_data['warehouse']}"
    response = RestClient.get url    
    return JSON.parse(response)       
  end


  def case_details(case_data)
    url = Properties.getUrl + "/case/#{case_data['id']}?client=#{case_data['client']}&warehouse=#{case_data['warehouse']}"   
    response = RestClient.get url    
    return JSON.parse(response)       
  end
  
  def case_update_header(id, app_parameters, fields_to_update)
    
    url = Properties.getUrl + "/case/#{id}/update_header"   
    response = RestClient.post(url, 
    app_parameters: app_parameters,
    fields_to_update: fields_to_update) { | responses, request, result, &block |
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

  def case_add_header(app_parameters, fields_to_update)
    url = Properties.getUrl + "/case/add_header"   
    response = RestClient.post(url, 
    app_parameters: app_parameters,
    fields_to_update: fields_to_update) { | responses, request, result, &block |
      case responses.code
      when 200, 422
        responses
      when 201  
        message = JSON.parse(responses)  
        resource_url = Properties.getUrl + message["content"][0]["link"] 
        app_parameters = app_parameters.merge(expand: "Yes")
        response = RestClient.post(resource_url, app_parameters)
        return JSON.parse(response)    
     else
      message = responses.nil? ? {} : JSON.parse(responses)["message"] 
      {status: responses.code, message: [message]}.to_json
    end
    }     
    return JSON.parse(response)  
  end


  def case_add_detail(app_parameters, fields_to_update)
    url = Properties.getUrl + "/case/add_detail"   
    response = RestClient.post(url, 
    app_parameters: app_parameters,
    fields_to_update: fields_to_update) { | responses, request, result, &block |
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


  def case_update_detail(id, app_parameters, fields_to_update)
    url = Properties.getUrl + "/case/#{id}/update_detail"
    response = RestClient.post(url, 
    app_parameters: app_parameters,
    fields_to_update: fields_to_update) { | responses, request, result, &block |
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