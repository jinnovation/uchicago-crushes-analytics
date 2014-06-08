class Crush < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :post

  validates :num_tags, :user_id, :post_id, {
    presence: true,
    allow_blank: false,
  }

  validates :user_id, {
    uniqueness: { scope: :post_id }
  }

  validates :num_tags, {
    numericality: { greater_than: 0 },
  }

  def quotient
    # TODO: placeholder
    Random.rand(100).to_f / 100
  end
  
end
