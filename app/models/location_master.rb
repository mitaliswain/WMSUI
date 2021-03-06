require 'rest_client'

class LocationMaster
  
  URL = '/location_master'
  
  def initialize(token)
    @token = token
  end
  
  def location_list(params = '')
    
    url = Properties.getUrl + URL
    response = RestClient.get url, {authorization: @token} 
    return JSON.parse(response)       
  end

  def location_details(location)
    url = Properties.getUrl + "#{URL}/#{location['location_id']}?client=#{location['client']}&warehouse=#{location['warehouse']}"
    response = RestClient.get url, {authorization: @token}
    return JSON.parse(response)
  end


  def update_location_master(id, app_parameters, fields_to_update)
    
    url = Properties.getUrl + "#{URL}/#{id}"
    response = RestClient.put(url, 
    app_parameters: app_parameters,
    fields_to_update: fields_to_update, authorization: @token) { | responses, request, result, &block |

      case responses.code

      when 200, 422,204
        responses
        
      when 201
        message = JSON.parse(responses)
        resource_url = Properties.getUrl + message["content"][0]["link"]
        response = RestClient.get(resource_url)
        return JSON.parse(response)
       
     else
       message = responses.nil? ? {} : JSON.parse(responses)['message']
      {status: responses.code, message: message}.to_json
    end    
    }    
    return JSON.parse(response)  
  end

  def add_location_master(app_parameters, fields_to_update)
    url = Properties.getUrl + URL
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
          response = RestClient.get(resource_url)
          return JSON.parse(response)
        
        else
          message = responses.nil? ? {} : JSON.parse(responses)["message"]
          {status: responses.code, message: [message]}.to_json
      end
    }
    return JSON.parse(response)
  end

end