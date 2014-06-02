class Crush < ActiveRecord::Base
  belongs_to :user
  belongs_to :post
end
