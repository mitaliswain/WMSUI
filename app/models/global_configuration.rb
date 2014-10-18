require 'rest_client'

class GlobalConfiguration
  
  def configuration_list(params = {})    
    
    url = Properties.getUrl + "/configuration" 
    response = RestClient.get url, {:params => {:selection => params.to_json}}
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