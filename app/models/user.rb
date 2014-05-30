class User < ActiveRecord::Base
  has_many :crushes

  validates :name, {
    presence: true,
    uniqueness: { case_sensitive: false },
    allow_blank: false,
  }

  validates :num_crushes, {
    presence: true,
    allow_blank: false,
    numericality: { only_integer: true },
  }
end
