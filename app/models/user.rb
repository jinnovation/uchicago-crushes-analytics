class User < ActiveRecord::Base
  # TODO: double-check attr_accessors
  has_many :crushes
  has_many :posts, through: :crushes

  validates :name, {
    presence: true,
    allow_blank: false,
  }

  validates :pic_url_small, {
    presence: true,
    allow_blank: false,
  }

  validates :pic_url_medium, {
    presence: true,
    allow_blank: false,
  }

  validates :pic_url_large, {
    presence: true,
    allow_blank: false,
  }

  # def fb_create!(fb_data)
  #   User.create!(name: fb_data[TAG_NAME_FULL],
  #                pic_url_small: @graph.get_picture(fb_data["id"],
  #                                                  width: "50",
  #                                                  height: "50"),
  #                pic_url_medium: @graph.get_picture(fb_data["id"],
  #                                                   width: "100",
  #                                                   height:"100"),
  #                pic_url_large: @graph.get_picture(fb_data["id"],
  #                                                  width: "200",
  #                                                  height: "200"),
  #                profile_url: fb_data[TAG_PROFILE_LINK])
  # end
end
