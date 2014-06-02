class Crush < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :post

  validates :num_tags, {
    presence: true
  }
  
end
