require 'spec_helper'

describe Post do
  it { should respond_to :content }
  it { should respond_to :fb_url }
  it { should respond_to :fb_id }
  it { should respond_to :fb_created_time }

  it "should not have duplicate posts" do
    pending
  end

  it "should have at least one associated User" do
    pending
  end

end
