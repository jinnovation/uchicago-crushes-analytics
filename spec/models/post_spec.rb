require 'spec_helper'
require 'shared_examples'

describe Post do
  
  before do
    @post = FactoryGirl::create(:post)
  end

  subject { @post }

  it { should respond_to :content }
  it { should respond_to :fb_id }
  it { should respond_to :fb_created_time }

  it { should respond_to :crushes }

  it { should respond_to :fb_url }
  it { should respond_to :user_highest_score }
  it { should respond_to :total_tag_count }

  it { should be_valid }

  describe "content" do
    subject { @post.content }
    it_behaves_like "table entry"
  end

  describe "fb_id" do
    subject { @post.fb_id }
    it_behaves_like "table entry"
  end

  describe "fb_created_time" do
    subject { @post.fb_created_time }
    it_behaves_like "table entry"
  end

  describe "user_highest_score" do
    pending
  end

  describe "total_tag_count" do
    pending
  end

end
