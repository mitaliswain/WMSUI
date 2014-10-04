require 'test_helper'

class ShipmentReceiveTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
 test "reset shipment" do
   sh = ShipmentReceive.new
   shipment =   [
                  {"name" => 'shipment_nbr',  "description"=> "Shipment" ,  "value" => 'ab', "validated" => true, "to_validate" => true},
                  {"name" => 'location',  "description"=> "Location" ,  "value" => 'cd', "validated" => true, "to_validate" => true},
                  {"name" => 'case',      "description"=> "Case", "value" => 's', "validated" => true, "to_validate" => true},
                  {"name" => 'item',      "description"=> "Item" , "value" => 's', "validated" => true, "to_validate" => true},
                  {"name" => 'quantity',  "description"=> "Quantity",  "value" => 's', "validated" => true, "to_validate" => true},
                  {"name" => 'inner_pack',"description"=> "Inner Pack",   "value" => 's', "validated" => true ,"to_validate" => false }
                ]
   sh1 = sh.reset_shipment(shipment)
   assert_equal(sh1[0]["value"], shipment[0]["value"], "Shipment value not changed")
   assert_equal(sh1[1]["value"], shipment[1]["value"], "Location value not changed")
   assert_equal(sh1[0]["validated"], true, "Shipment need not be validated again")
   assert_equal(sh1[1]["validated"], true, "Location need not be validated again")
   
   assert_equal(sh1[2]["value"], "" , "case value changed to blank")
   assert_equal(sh1[2]["validated"], false , "case needs to be validated again")

   assert_equal(sh1[3]["value"], "" , "item value changed to blank")
   assert_equal(sh1[3]["validated"], false , "item needs to be validated again")

   assert_equal(sh1[4]["value"], "" , "quantity value changed to blank")
   assert_equal(sh1[4]["validated"], false , "quantity needs to be validated again")

 end

end   