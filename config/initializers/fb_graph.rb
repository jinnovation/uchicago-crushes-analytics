Koala.config.api_version = "v2.0"

TAG_COMMENTS             = "comments"
TAG_DATA                 = "data"
TAG_MSG_TAGS             = "message_tags"
TAG_TYPE                 = "type"
TAG_USER                 = "user"
TAG_ID                   = "id"
TAG_NAME_FULL            = "name"
TAG_PROFILE_LINK         = "link"
TAG_MSG                  = "message"
TAG_TIME                 = "created_time"
TAG_FIRST_NAME           = "first_name"
TAG_LAST_NAME            = "last_name"

FB_URL_BASE              = "https://www.facebook.com/"

@oauth = Koala::Facebook::OAuth.new(ENV["FB_APP_ID"], ENV["FB_APP_SECRET"])
@token = @oauth.get_app_access_token
@graph = Koala::Facebook::API.new(@token, ENV["FB_APP_SECRET"])
