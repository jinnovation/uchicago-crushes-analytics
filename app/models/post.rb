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

  def quotients_calc
    # TODO:
    # if post contains a full name:
    #   primary_user_base = users that match full name
    # else if post contains a first name:
    #   primary_user_base = users that match first name
    # else if post contains a last name:
    #   primary_user_base = users that match last name
    # else
    #   primary_user_base = []
    # end
    #
    # if not primary_user_base.empty?
    #   primary_user_base.each do |user|
    #     Crush.find().quotient = 1.0 / primary_user_base.length
    #   end
    #   
    #   every_other_user.each do |user|
    #     Crush.find().quotient = 0.0
    #   end
    # else
    #   every_other_user.each do |user|
    #     Crush.find().quotient = 1.0 / every_other_user.length
    #   end
    # end
    
  end
end
