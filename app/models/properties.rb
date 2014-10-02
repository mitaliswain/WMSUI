class Properties
        
  def self.getUrl
    if Rails.env.production?
     'http://wmsservice.herokuapp.com'
    else
      'http://localhost:3001'    
    end
  end

end