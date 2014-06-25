class User < ActiveRecord::Base
  has_many :crushes
  has_many :posts, through: :crushes

  validates :first_name, :last_name, :pic_url_small, :pic_url_medium,
  :pic_url_large, :profile_url, {
    presence: true,
    allow_blank: false,
  }

  validates :pic_url_small, :pic_url_medium, :pic_url_large, :profile_url, {
    uniqueness: { case_sensitive: false },
  }

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

  def search(query)
    if query
      # TODO: "name" should be something else
      find :all, conditions: ['name LIKE ?', "%#{query}%"] 
    else
      find :all      
    end
  end
end
