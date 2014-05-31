Koala.config.api_version = 'v2.0'

TAG_COMMENTS  = "comments"
TAG_DATA      = "data"
TAG_MSG_TAGS  = "message_tags"
TAG_TYPE      = "type"
TAG_USER      = "user"
TAG_ID        = "id"
TAG_NAME_FULL = "name"

@oauth = Koala::Facebook::OAuth.new(ENV["FB_APP_ID"], ENV["FB_APP_SECRET"])
@token = @oauth.get_app_access_token
@graph = Koala::Facebook::API.new(@token, ENV["FB_APP_SECRET"])