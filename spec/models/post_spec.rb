require 'spec_helper'
require 'shared_examples'

describe Post do
  before do
    @user   = FactoryGirl.create :user
    @user1  = FactoryGirl.create :user

    @post   = FactoryGirl.create :post, content: @user.full_name +
      Faker::Lorem.paragraph(4)

    @crush  = FactoryGirl.create :crush, user_id: @user.id,  post_id: @post.id,
      num_tags: 4
    @crush1 = FactoryGirl.create :crush, user_id: @user1.id, post_id: @post.id,
      num_tags: 6

    @post.quotients_calc
  end

  subject { @post }

  it { should respond_to :content }
  it { should respond_to :fb_id }
  it { should respond_to :fb_created_time }

  it { should respond_to :crushes }
  it { should respond_to :users }

  it { should respond_to :fb_url }
  it { should respond_to :user_highest_score }
  it { should respond_to :total_tag_count }
  it { should respond_to :quotients_calc }

  it { should be_valid }

  describe :content do
    subject { @post.content }
    it_behaves_like "table entry"
  end

  describe :fb_id do
    subject { @post.fb_id }
    it_behaves_like "table entry"
  end

  describe :fb_created_time do
    subject { @post.fb_created_time }
    it_behaves_like "table entry"
  end

  describe :user_highest_score do
    it "should not be nil" do
      expect(@post.user_highest_score).not_to be_nil
    end

    it "should return the right user" do
      expect(@post.user_highest_score).to eq @user
    end
  end

  describe :total_tag_count do
    it "should not be nil" do
      expect(@post.total_tag_count).not_to be_nil
    end

    it "should return the right value" do
      expect(@post.total_tag_count).to eq @crush.num_tags+@crush1.num_tags
    end
  end

end
