class Post < ActiveRecord::Base
  has_many :crushes
  has_many :users, through: :crushes

  # TODO: double-check attr_accessors

  validates :content, :fb_created_time, :fb_id, {
    presence: true,
    allow_blank: false,
  }

  def fb_url
    FB_URL_BASE + self.fb_id
  end
end
