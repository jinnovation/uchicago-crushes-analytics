require 'spec_helper'

describe Post do

  before do
    @post = Post.new(content: "foobar", fb_created_time: DateTime.current,
                     fb_id: "1275832715")
  end

  subject { @post }

  it { should respond_to :content }
  it { should respond_to :fb_id }
  it { should respond_to :fb_created_time }
  it { should respond_to :fb_url }

  it { should be_valid }

  describe "when content is not present" do
    before { @post.content = "" }
    it { should_not be_valid }
  end

  describe "when fb_id is not present" do
    before { @post.fb_id = "" }
    it { should_not be_valid }
  end

  describe "when fb_created_time is not present" do
    before { @post.fb_created_time = nil }
    it { should_not be_valid }
  end

  it "should not have a duplicate" do
    pending
  end

end
