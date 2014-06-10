class StaticPagesController < ApplicationController
  def home
    @users = User.all
    @posts = Post.all
  end

  def analytics
  end

end
