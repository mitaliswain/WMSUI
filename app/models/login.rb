require 'rest_client'

class Login
  
  def login(client, userid, password)
    url = Properties.getUrl + "/authenticate/signin"
    response = RestClient.post(url, 
    user_details: {client: client, user_id: userid, password: password}) { | responses, request, result, &block |

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