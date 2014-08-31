require 'spec_helper'
require 'shared_examples'

describe User do
  before do
    @user  = FactoryGirl.create :user
    @user1 = FactoryGirl.create :user
  end

  subject { @user }
  it { should respond_to :posts }

  describe :fb_id do
    it "is an instance method" do
      expect(@user).to respond_to :fb_id
    end
  end

  describe :posts_of_highest_quotient do
    it "is an instance method" do
      expect(@user).to respond_to :posts_of_highest_quotient
    end

    it "returns Posts for which User has highest quotient"
  end

  describe :first_name do
    it "is an instance method" do
      expect(@user).to respond_to :first_name
    end

    it_behaves_like "table entry" do
      subject { @user.first_name }
    end

    it "is capitalized" do
      expect(@user.first_name).to be_capitalized
    end
    
    it "is not unique" do
      @user.first_name = @user1.first_name

      expect(@user).to be_valid
    end
  end

  describe :last_name do
    it "is an instance method" do
      expect(@user).to respond_to :last_name
    end
    
    it_behaves_like "table entry" do
      subject { @user.last_name }
    end
    
    it "is capitalized" do
      expect(@user.last_name).to be_capitalized
    end

    it "is not unique" do
      @user.last_name = @user1.last_name

      expect(@user).to be_valid
    end
  end

  describe :full_name do
    it "is an instance method" do
      expect(@user).to respond_to :full_name
    end

    it "is not unique" do
      @user.first_name = @user1.first_name
      @user.last_name = @user1.last_name

      expect(@user).to be_valid
    end
  end

  describe :profile_url do
    it "is an instance method" do
      expect(@user).to respond_to :profile_url
    end
    
    it_behaves_like "table entry" do
      subject { @user.profile_url }
    end

    it "is not a duplicate" do
      expect {
        @user.profile_url = @user1.profile_url
      }.to change { @user.valid? }.to false
    end
  end

  describe :pic_url_small do
    it "is an instance method" do
      expect(@user).to respond_to :pic_url_small
    end
    
    it_behaves_like "table entry" do
      subject { @user.pic_url_small }
    end

    it "is unique" do
      expect {
        @user.pic_url_small = @user1.pic_url_small
      }.to change { @user.valid? }.to false
    end
  end

  describe :pic_url_medium do
    it "is an instance method" do
      expect(@user).to respond_to :pic_url_medium
    end
    
    it_behaves_like "table entry" do
      subject { @user.pic_url_medium }
    end

    it "is unique" do
      expect {
        @user.pic_url_medium = @user1.pic_url_medium
      }.to change { @user.valid? }.to false
    end
  end

  describe :pic_url_large do
    it "is an instance method" do
      expect(@user).to respond_to :pic_url_large
    end
    
    it_behaves_like "table entry" do
      subject { @user.pic_url_large }
    end

    it "is unique" do
      expect {
        @user.pic_url_large = @user1.pic_url_large
      }.to change { @user.valid? }.to false
    end
  end

  describe :latest_post do
    it "is an instance method" do
      expect(@user).to respond_to :latest_post
    end

    it "returns the latest post by Datetime" do
      latest_crush = create :crush, user: @user
      latest_post  = latest_crush.post

      expect(@user.latest_post).to eq latest_post

      latest_post.destroy
    end
  end
end
