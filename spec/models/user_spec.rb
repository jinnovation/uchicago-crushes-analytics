require 'spec_helper'
require 'shared_examples'

describe User do
  before do
    @user = FactoryGirl::create(:user)
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
