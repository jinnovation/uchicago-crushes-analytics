require 'spec_helper'
require 'shared_examples'

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

end
