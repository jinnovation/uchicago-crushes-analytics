class Post < ActiveRecord::Base
  has_many :crushes
  has_many :users, through: :crushes

  validates :content, :fb_created_time, :fb_id, {
    presence: true,
    allow_blank: false,
  }

  def total_tag_count
    self.crushes.inject(0) do |sum,crush|
      sum += crush.num_tags
    end
  end

  # TODO: validate that sum of all crush quotients == 1.0

  def fb_url
    FB_URL_BASE + self.fb_id
  end

  def user_highest_score
    # FIXME: placeholder definition
    self.users.first
  end
end
