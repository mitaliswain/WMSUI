require 'rest_client'

class UserMaster
  
  def initialize(token)
    @token = token
  end
  
  ENDPOINT_URL = '/user_master' 
  
  def user_list(params = '')
    
    url = Properties.getUrl + ENDPOINT_URL
    response = RestClient.get url, {authorization: @token} #, {:params => {:selection => params.to_json}}
    return JSON.parse(response)       
  end

  def user_details(user)
    url = Properties.getUrl + "#{ENDPOINT_URL}/#{user['id']}?client=#{user['client']}"
    response = RestClient.get url, {authorization: @token}
    return JSON.parse(response)
  end


  def update_user_master(id, app_parameters, fields_to_update)
    
    url = Properties.getUrl + "#{ENDPOINT_URL}/#{id}"
    response = RestClient.put(url, 
    app_parameters: app_parameters,
    fields_to_update: fields_to_update,
    authorization: @token) { | responses, request, result, &block |

      case responses.code

      when 200, 201, 422,204
        responses
     else
       message = responses.nil? ? {} : JSON.parse(responses)['message']
      {status: responses.code, message: message}.to_json
    end    
    }    
    return JSON.parse(response)  
  end

  def add_user_master(app_parameters, fields_to_update)
    url = Properties.getUrl + ENDPOINT_URL
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