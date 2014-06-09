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

  it { should be_valid }

  describe :first_name do
    it_behaves_like "table entry"
  end

  describe :last_name do
    it_behaves_like "table entry"
  end

  describe :profile_url do
    it_behaves_like "table entry"
  end

  describe "when profile url is a duplicate" do
    before { @user.profile_url = @user1.profile_url }
    it { should_not be_valid }    
  end

  describe :pic_url_small do
    it_behaves_like "table entry"
  end

  describe :pic_url_medium do
    it_behaves_like "table entry"
  end

  describe :pic_url_large do
    it_behaves_like "table entry"
  end  
end
