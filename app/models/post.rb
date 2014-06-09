class Post < ActiveRecord::Base
  has_many :crushes
  has_many :users, through: :crushes

  validates :content, :fb_created_time, :fb_id, {
    presence: true,
    allow_blank: false,
  }

  def total_tag_count
    self.crushes.inject(0) do |sum,crush|
      sum += crush.num_tags
    end
  end

  # TODO: validate that 1.0 - (sum of all crush quotients) < 0.2 (or other val)

  def fb_url
    FB_URL_BASE + self.fb_id
  end

  def user_highest_score
    crush_highest = self.crushes.sort_by {|crush| crush.quotient}.reverse.first

    if crush_highest.nil? then nil else crush_highest.user end
  end

  def quotients_calc
    # FIXME: THIS IS ALL HIDEOUS
    
    # FIXME: what if post contains substring of {first,last,full} name
    # FIXME: account for multiple {first,last,full} name in Post.contents
    users_mentioned_full = self.users.find_all do |user|
      self.content.include?(user.full_name) ||
        self.content.include?(user.first_name.downcase + user.last_name) ||
        self.content.include?(user.first_name + user.last_name.downcase) ||
        self.content.include?(user.full_name.downcase)
    end

    users_mentioned_first = self.users.find_all do |user|
      self.content.include?(user.first_name) ||
        self.content.include?(user.first_name.downcase)
    end

    users_mentioned_last = self.users.find_all do |user|
      self.content.include?(user.last_name) ||
        self.content.include?(user.last_name.downcase)
    end

    # FIXME: got to be a cleaner way to do this
    post_contains_full_name = users_mentioned_full.any?
    post_contains_first_name = users_mentioned_first.any?
    post_contains_last_name = users_mentioned_last.any?

    if    post_contains_full_name
      primary_user_base = users_mentioned_full
    elsif post_contains_first_name
      primary_user_base = users_mentioned_first
    elsif post_contains_last_name
      primary_user_base = users_mentioned_last
    else
      primary_user_base = []
    end

    every_other_user = self.users.select do |user|
      not primary_user_base.include?(user)
    end

    if primary_user_base.any?
      puts "DISTRIB PRIMARY_USER_BASE"

      primary_base_total_tags = primary_user_base.inject(0) do |sum,user|
        sum += Crush.find_by_user_id_and_post_id(user.id, self.id).num_tags
      end

      primary_user_base.each do |user|
        crush_curr = Crush.find_by_user_id_and_post_id(user.id, self.id)

        quotient_old = crush_curr.quotient
        primary_quotient_val_base = (crush_curr.num_tags.to_f / primary_base_total_tags.to_f).round 2
        primary_quotient_val_mod = 1.0 # TODO

        crush_curr.update_attributes(quotient: primary_quotient_val_base * primary_quotient_val_mod)
        puts "Crush(#{user.full_name}, #{self.id}).quotient: #{quotient_old}"\
        " => #{crush_curr.quotient}"
      end

      # FIXME: not working for every single case
      puts "EVERY_OTHER_USER.QUOTIENT = 0"
      other_quotient_val = 0.0
      every_other_user.each do |user|
        crush_curr = Crush.find_by_user_id_and_post_id(user.id, self.id)

        quotient_old = crush_curr.quotient

        crush_curr.update_attributes(quotient: other_quotient_val)
        puts "Crush(#{user.full_name}, #{self.id}).quotient: #{quotient_old}"\
        " => #{crush_curr.quotient}"
      end
    else
      puts "DISTRIB TO EVERY_OTHER_USER"

      other_base_total_tags = every_other_user.inject(0) do |sum,user|
        sum += Crush.find_by_user_id_and_post_id(user.id, self.id).num_tags
      end

      every_other_user.each do |user|
        crush_curr = Crush.find_by_user_id_and_post_id(user.id, self.id)

        quotient_old = crush_curr.quotient
        quotient_val_base = (crush_curr.num_tags.to_f / other_base_total_tags.to_f).round 2
        quotient_val_mod = 1.0  # TODO

        crush_curr.update_attributes(quotient: quotient_val_base * quotient_val_mod)
        puts "Crush(#{user.full_name}, #{self.id}).quotient: #{quotient_old}"\
        " => #{crush_curr.quotient}"
      end
    end
  end

end
