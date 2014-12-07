require 'rest_client'

class CasePutaway
  attr_accessor :putaway, :basic_parameters, :config_list

  def initialize(putaway, basic_parameters)
    @putaway=putaway
    @basic_parameters = basic_parameters
    @config_list = GlobalConfiguration.new.configuration_list_key_value(module: 'PUTAWAY')
  end

  def prepare_putaway_receiving_screen
    self.putaway
  end

  def process_putaway(to_validate, value)
    response = any_more_to_validate? ?  validate_putaway_and_reset_the_input(to_validate, value) : case_putaway_and_reset_the_input
    set_putaway_value_from_input(to_validate, "validated", true)  if successfully_validated?(response)
    return {putaway: self.putaway, status: response["status"], error: get_error_message(response)}
  end

  private

  def validate_putaway_and_reset_the_input(to_validate, value)

    set_putaway_value_from_input(to_validate, "value", value)
    response = validate_putaway(to_validate)
    response
  end

  def successfully_validated?(response)
    response["status"] == '200'
  end

  def case_putaway_and_reset_the_input
    response = case_putaway
    reset_putaway if response["status"] == "201"
    response
  end

  def all_validation_completed_successfully?(response)
    response["status"] == '200' && !any_more_to_validate?
  end


  def get_error_message(response)
    p response
    case response["status"]
      when "200"
        ""
      when "201", "415"
        response["message"]
      when "422"
        response["errors"][0]["message"]
      else
        "Error in processing"
    end

  end

  def any_more_to_validate?
    self.putaway.each do |putaway_component|
      if putaway_component["validated"] == false && putaway_component["to_validate"] == 'Yes'
        return true
      end
    end
    false
  end

  def set_putaway_value_from_input(putaway_element, property, value)
    self.putaway.each_with_index do |element, index|
      if element["name"] == putaway_element
        self.putaway[index][property] = value
        break
      end
    end
    p putaway
    putaway
  end

  def putaway_case

    putaway = extract_putaway
    url = Properties.getUrl + '/putaway/' + putaway["case_id"] + '/receive'

    putaway = {
        client:     self.basic_parameters["client"],
        warehouse:  self.basic_parameters["warehouse"],
        channel:    nil,
        building:   nil,
        case_id:    putaway["case_id"],
        location:   putaway["location"]
    }
    response = RestClient.post(url, putaway: putaway){ | responses, request, result, &block |
      case responses.code
        when 200, 201, 422, 204
          responses
        else
          message = responses.nil? ? {} : JSON.parse(responses)["message"]
          {status: responses.code, message: message}.to_json
      end
    }

    return JSON.parse(response)

  end

  def validate_putaway(to_validate)
    putaway_payload = extract_putaway
    url = Properties.getUrl + '/putaway/' + to_validate + '/validate'

    putaway_hash = {
        client:     self.basic_parameters["client"],
        warehouse:  self.basic_parameters["warehouse"],
        channel:    nil,
        building:   nil,
        case_id:    putaway_payload["case_id"],
        location:   putaway_payload["location"]
    }
    response = RestClient.post(url, putaway: putaway_hash) { | responses, request, result, &block |
      case responses.code
        when 200, 201, 422, 204
          responses
        else
          message = responses.nil? ? {} : JSON.parse(responses)["message"]
          {status: responses.code, message: message}.to_json
      end
    }
    return JSON.parse(response)
  end


  def extract_putaway
    putaway_payload = {}
    self.putaway.each do |putaway_info|
        putaway_payload[putaway_info["name"]] = putaway_info["value"]
    end
    putaway_payload
    end


  end
