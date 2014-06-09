class Crush < ActiveRecord::Base
  
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
  end

  def quotient_calc
    # TODO: work-in-progress
    # CONSIDERATIONS:
    # - post body contains only a last name
    # - post contains subset of either first or last name
    
    post_body         = self.post.content

    ratio_tags_to_total = self.num_tags.to_f / self.post.total_tag_count.to_f

    quotient_base     = ratio_tags_to_total
    quotient_modulate = 1.0

    # FIXME: got to be a cleaner way to do this
    post_is_nameless = self.post.users.find_all do |user|
      post_body.include? user.first_name
    end.empty?

    if post_body.include?(self.user.first_name)
      quotient_modulate = 1.0
      # TODO: account for multiple people having the same first name
    elsif post_body.include?(self.user.full_name)
      quotient_modulate = 1.0
      # TODO: account for multiple people having the same full names
    elsif post_is_nameless
      quotient_modulate = 1.0
    else
      quotient_modulate = 1.0
    end

    (quotient_base * quotient_modulate).round 2
  end

  def update_tag_time(tag_time)
    self.last_tag_time = tag_time if tag_time > self.last_tag_time
  end
  
end
