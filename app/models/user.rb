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
    # TODO: account for: {first, last, full} name
    # - run search for each case
    # - each append to return
    if query.present?
      # TODO: "name" should prob be something else
      find :all, conditions: ['name LIKE ?', "%#{query}%"]
    else
      find :all
    end

    # TODO: order by match quality
    # TODO: write match-quality determination algorithm
  end
end
