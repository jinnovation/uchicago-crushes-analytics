module UsersHelper

  def populate
    @graph = Koala::Facebook::API.new(OAUTH_ACCESS_TOKEN)
    
  end
end
