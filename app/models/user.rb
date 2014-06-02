class User < ActiveRecord::Base
  # TODO: double-check attr_accessors
  has_many :posts

  validates :name, {
    presence: true,
    allow_blank: false,
  }

  validates :pic_url, {
    presence: true,
    allow_blank: false,
  }
end
