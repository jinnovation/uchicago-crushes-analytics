class User < ActiveRecord::Base
  # TODO: double-check attr_accessors
  has_many :crushes

  validates :name, {
    presence: true,
    uniqueness: { case_sensitive: false },
    allow_blank: false,
  }
end
