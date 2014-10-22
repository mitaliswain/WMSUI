require 'rest_client'

class GlobalConfiguration
  
  def configuration_list(params = {})    
    
    url = Properties.getUrl + "/configuration" 
    response = RestClient.get url, {:params => {:selection => params.to_json}}
    return JSON.parse(response)       
  end
  
  def configuration_update(id, app_parameters, fields_to_update)
    
    url = Properties.getUrl + "/configuration/#{id}"   
    response = RestClient.put(url, 
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
  
 
 def configuration_list_key_value(params = {})
   config_key_value_pair = {}
   configuration_list(params).each do |config|
     config_key_value_pair = config_key_value_pair.merge({config["key"] => config["value"]})
   end
   config_key_value_pair.symbolize_keys
 end
  
end