Koala.config.api_version = "v2.0"

FB_URL_BASE              = "https://www.facebook.com/"

@oauth = Koala::Facebook::OAuth.new(ENV["FB_APP_ID"], ENV["FB_APP_SECRET"])
@token = @oauth.get_app_access_token
@graph = Koala::Facebook::API.new(@token, ENV["FB_APP_SECRET"])
