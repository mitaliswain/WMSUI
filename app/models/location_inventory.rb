require 'rest_client'

class LocationInventory
  API_URL = 'location_inventory'
 
  def initialize(token)
    @token = token
  end
  
  def location_inventory_list(params = '')
    JSON.parse(RestClient.get "#{Properties.getUrl}/#{API_URL}", {authorization: @token})  
  end

  def location_inventory_details(location_inventory)
    JSON.parse(RestClient.get "{Properties.getUrl}/#{API_URL}/#{location_inventory['location_inventory_id']}?client=#{location_inventory['client']}&warehouse=#{location_inventory['warehouse']}", 
    {authorization: @token})
  end


  def location_inventory(id, app_parameters, fields_to_update)
    
    url = "#{Properties.getUrl}/#{API_URL}/#{id}"
    response = RestClient.put(url, 
    app_parameters: app_parameters,
    fields_to_update: fields_to_update, authorization: @token) { | responses, request, result, &block |

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

  def add_item_master(app_parameters, fields_to_update)
    url = "#{Properties.getUrl}/{API_URL}/"
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