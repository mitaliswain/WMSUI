require 'rest_client'

class ItemMaster
  
  def initialize(token)
    @token = token
  end
  
  def item_list(params = '')
    
    url = Properties.getUrl + '/item_master'
    response = RestClient.get url, {authorization: @token}
    return JSON.parse(response)       
  end

  def item_details(item)
    url = Properties.getUrl + "/item_master/#{item['item_id']}?client=#{item['client']}&warehouse=#{item['warehouse']}"
    response = RestClient.get url, {authorization: @token}
    return JSON.parse(response)
  end


  def update_item_master(id, app_parameters, fields_to_update)
    
    url = Properties.getUrl + "/item_master/#{id}"
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
    url = Properties.getUrl + '/item_master/'
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