require 'spec_helper'
require 'shared_examples'

describe User do
  before do
    @user = User.new(first_name: "Foo", last_name: "Bar",
                     profile_url: "https://www.facebook.com/app_scoped_user_id/87587578",
                     pic_url_small:
                     "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xpf1/t1.0-1/c0.0.50.50/p50x50/1797385_10203997531681550_1410745674697109627_t.jpg",
                     pic_url_medium:
                     "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xpf1/t1.0-1/c0.0.100.100/p100x100/1797385_10203997531681550_1410745674697109627_a.jpg",
                     pic_url_large:
                     "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xpf1/t1.0-1/c0.0.200.200/p200x200/1797385_10203997531681550_1410745674697109627_n.jpg",
                     fb_id: "10204018734971619")
  end

  subject { @user }

  it { should respond_to :first_name }
  it { should respond_to :last_name }
  it { should respond_to :full_name }
  it { should respond_to :profile_url }
  it { should respond_to :pic_url_small }
  it { should respond_to :pic_url_medium }
  it { should respond_to :pic_url_large }
  it { should respond_to :fb_id }

  it { should be_valid }

  describe "first_name" do
    subject { @user.first_name }
    it_behaves_like "table entry"
  end

  describe "last_name" do
    subject { @user.last_name }
    it_behaves_like "table entry"
  end

  describe "profile_url" do
    subject { @user.profile_url }
    it_behaves_like "table entry"
  end

  describe "pic_url_small" do
    subject { @user.pic_url_small }
    it_behaves_like "table entry"
  end

  describe "pic_url_medium" do
    subject { @user.pic_url_medium }
    it_behaves_like "table entry"
  end

  describe "pic_url_large" do
    subject { @user.pic_url_large }
    it_behaves_like "table entry"
  end
end
