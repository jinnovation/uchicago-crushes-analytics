class User < ActiveRecord::Base
  has_many :crushes
  has_many :posts, through: :crushes

  before_save do
    first_name.capitalize!
    last_name.capitalize!
  end

  validates :first_name, :last_name, :pic_url_small, :pic_url_medium,
  :pic_url_large, :profile_url, {
    presence: true,
    allow_blank: false,
  }

  validates :pic_url_small, :pic_url_medium, :pic_url_large, :profile_url, {
    uniqueness: { case_sensitive: false },
  }

  def self.select_most_crushes(count=1)
    users_sorted = self.all.sort_by(&:num_crushes).reverse

    if count==1
      users_sorted.first
    else
      users_sorted.first count
    end
  end

  def num_crushes
    self.crushes.count
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def mean_quotient
    sum = 0.0
    self.crushes.each do |crush|
      sum += crush.quotient
    end

    sum / self.crushes.length
  end

  def latest_post
    self.posts.sort_by(&:fb_created_time).reverse.first
  end
end
