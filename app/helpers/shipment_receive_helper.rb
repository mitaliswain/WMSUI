module ShipmentReceiveHelper
  

  def editable_input(receive)
      
      content_tag :div, :class => "field" do
       concat(content_tag(:label,receive["description"] + ": "))
        concat(text_field_tag('value','', :class => 'medium new_value')) if (receive["validated"] == false)
        concat(content_tag(:label,receive["value"])) if (receive["validated"] == true)      
      end
  end
  
end
