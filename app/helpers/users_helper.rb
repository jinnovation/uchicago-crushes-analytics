module UsersHelper

  def user_pic(user)
    unless user.nil?
      image_tag(user.pic_url_medium)
    else
      holder_tag("100x100", "Unknown")
    end
  end

  def user_name(user)
    if user.nil?
      ""
    else
      user.full_name
    end
  end

  def user_quotient(user, post)
    if user.nil?
      ""
    else
      Crush.find_by_user_id_and_post_id(user.id, post.id).quotient.to_s end
  end
end
