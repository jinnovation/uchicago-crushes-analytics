class Post < ActiveRecord::Base
  belongs_to :user
  # TODO: double-check attr_accessors

  # TODO: add facebook timestamp
  
  validates :content, {
    presence: true,
    allow_blank: false,
  }

  validates :user_id, {
    presence: true,
    allow_blank: false,
  }
end
