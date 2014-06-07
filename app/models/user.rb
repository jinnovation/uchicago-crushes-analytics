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

  # TODO: move this into Crush relation
  def quotient(post)
    # TODO: placeholder
    Random.rand(100).to_f / 100
  end
end
