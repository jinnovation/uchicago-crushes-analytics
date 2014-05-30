class Crush < ActiveRecord::Base
  belongs_to :user

  validates :content, {
    presence: true,
    allow_blank: false,
  }

  validates :user_id, {
    presence: true,
    allow_blank: false,
  }
end
