class Crush < ActiveRecord::Base
  MAX_QUOTIENT_VAL = 1.0
  
  belongs_to :user
  belongs_to :post

  validates :num_tags, :user_id, :post_id, :last_tag_time, {
    presence: true,
    allow_blank: false,
  }

  validates :user_id, {
    uniqueness: { scope: :post_id }
  }

  validates :num_tags, {
    numericality: { greater_than: 0 },
  }

  def init
    self.quotient = 0.0
    self.num_tags = 0
  end

  def update_tag_time(tag_time)
    self.last_tag_time = tag_time if tag_time > self.last_tag_time
  end
  
end
