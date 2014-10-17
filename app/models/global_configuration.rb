require 'rest_client'

class GlobalConfiguration
  
  def self.configuration_list    
    url = Properties.getUrl + "/configuration/"   
    response = RestClient.get url    
    return JSON.parse(response)       
  end
  
end