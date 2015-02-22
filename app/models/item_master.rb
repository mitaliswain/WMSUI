require 'rest_client'

class ItemMaster
  
  def item_list(params = '')
    
    url = Properties.getUrl + '/item_master'
    response = RestClient.get url #, {:params => {:selection => params.to_json}}
    return JSON.parse(response)       
  end

  def self.item_details(item)
    url = Properties.getUrl + "/item_master/#{item['item_id']}?client=#{item['client']}&warehouse=#{item['warehouse']}"
    response = RestClient.get url
    return JSON.parse(response)
  end


  def update_item_master(id, app_parameters, fields_to_update)
    
    url = Properties.getUrl + "/item_master/#{id}"
    response = RestClient.put(url, 
    app_parameters: app_parameters,
    fields_to_update: fields_to_update) { | responses, request, result, &block |

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

end