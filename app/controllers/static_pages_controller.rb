class StaticPagesController < ApplicationController
  def dashboard
    @top_users = User.select_most_crushes 30
    @posts_latest = Post.latest 25
  end

  def analytics
  end

end
