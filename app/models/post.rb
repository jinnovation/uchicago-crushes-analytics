class Post < ActiveRecord::Base
  has_many :crushes
  has_many :users, through: :crushes

  # TODO: double-check attr_accessors

  # TODO: add facebook timestamp
  
  validates :content, {
    presence: true,
    allow_blank: false,
  }
end
