require 'rest_client'
class Shipment
  
  def self.receive(shipment)

    url = 'http://wmsservice.herokuapp.com/shipment/' + shipment["shipment_nbr"] + '/receive'
    #url = 'http://localhost:3001/shipment/' + shipment["shipment_nbr"] + '/receive'

    shipment = {
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
       } 
    puts shipment   
    response = RestClient.post url,
    shipment: shipment

      puts response
     return JSON.parse(response)
      
  end
  
  def self.validate(to_validate, shipment)
      
      url = 'http://wmsservice.herokuapp.com/shipment/' + to_validate + '/validate'
      #url = 'http://localhost:3001/shipment/' + to_validate + '/validate'
      
     shipment = {
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
       } 
    puts shipment   
    response = RestClient.post url,
    shipment: shipment

    puts response     
    return JSON.parse(response)
    
    
  end
  
  
end