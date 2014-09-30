class Properties
        
  def self.getUrl
    'http://localhost:3001'
    #'http://wmsservice.herokuapp.com'
    if Rails.env.production?
       'http://wmsservice.herokuapp.com'
    end     
  end

end