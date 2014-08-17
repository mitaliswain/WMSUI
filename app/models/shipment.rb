require 'rest_client'
class Shipment
  def self.shipment_details(shipment)

    url = "http://wmsservice.herokuapp.com/shipment/#{shipment['shipment_nbr']}?client=#{shipment['client']}&warehouse=#{shipment['warehouse']}"
    #url = "localhost:3002/shipment/#{shipment['shipment_nbr']}?client=#{shipment['client']}&warehouse=#{shipment['warehouse']}"   
    response = RestClient.get url    
    return JSON.parse(response)       
  end
  
  def self.shipment_details_update(shipment, field_to_update)

    url = "http://wmsservice.herokuapp.com/shipment/Shipment1/update"
    response = RestClient.post url, 
    shipment: shipment,
    field_to_update: field_to_update
      
    return JSON.parse(response)  
  end

  def self.receive(shipment)

    url = 'http://localhost:3001/shipment/' + shipment["shipment_nbr"] + '/receive'
    response = RestClient.post url,
        client:     shipment["client"], 
        warehouse:  shipment["warehouse"],
        channel:    nil,
        building:   nil,
        shipment_nbr:   shipment["shipment_nbr"],
        location:   shipment["location"],
        case_id:    shipment["case"],
        item:       shipment["item"],
        quantity:   shipment["quantity"],
        innerpack_qty:   shipment["inner_pack"]
      
     return JSON.parse(response)
      
  end
  
  def self.validate(to_validate, shipment)
      
      url = 'http://localhost:3001/shipment/' + to_validate + '/validate'
      response = RestClient.post url,
        client:     shipment["client"], 
        warehouse:  shipment["warehouse"],
        channel:    nil,
        building:   nil,
        shipment_nbr:   shipment["shipment_nbr"],
        location:   shipment["location"],
        case_id:    shipment["case"],
        item:       shipment["item"]

     return JSON.parse(response)
    
    
  end
  
  
end