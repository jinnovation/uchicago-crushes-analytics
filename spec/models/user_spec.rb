require 'spec_helper'
require 'shared_examples'

describe User do
  before do
    @user  = FactoryGirl.create :user
    @user1 = FactoryGirl.create :user
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

  it { should respond_to :posts }

  it { should be_valid }

  describe :first_name do
    subject { @user.first_name }
    it_behaves_like "table entry"
    it { should be_capitalized }
  end

  describe :last_name do
    subject { @user.last_name }
    it_behaves_like "table entry"

    it { should be_capitalized }
  end

  describe :profile_url do
    subject { @user.profile_url }
    it_behaves_like "table entry"
  end

  describe "with duplicate" do
    describe "profile_url" do
      before { @user.profile_url = @user1.profile_url }
      it { should_not be_valid }      
    end
    
    describe "first name" do
      before { @user.first_name = @user1.first_name }
      it { should be_valid }
    end

    describe "last name" do
      before { @user.last_name = @user1.last_name }
      it { should be_valid }
    end

    describe "full name" do
      before do
        @user.first_name = @user1.first_name
        @user.last_name = @user1.last_name
      end

      it { should be_valid }
    end
  end

  describe :pic_url_small do
    subject { @user.pic_url_small }
    it_behaves_like "table entry"
  end

  describe "with duplicate pic_url_small" do
    before { @user.pic_url_small = @user1.pic_url_small }
    it { should_not be_valid }
  end

  describe :pic_url_medium do
    subject { @user.pic_url_medium }
    it_behaves_like "table entry"
  end

  describe "with duplicate pic_url_medium" do
    before { @user.pic_url_medium = @user1.pic_url_medium }
    it { should_not be_valid }
  end

  describe :pic_url_large do
    subject { @user.pic_url_large }
    it_behaves_like "table entry"
  end

  describe "with duplicate pic_url_large" do
    before { @user.pic_url_large = @user1.pic_url_large }
    it { should_not be_valid }
  end
end
