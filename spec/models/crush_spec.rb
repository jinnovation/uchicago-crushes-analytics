require 'spec_helper'

describe Crush do
  it { should respond_to :content }
  it { should respond_to :user_id }
  it { should respond_to :post_url }

  it "should not have duplicate crushes" do
    pending
  end

  it "should have at least one associated User" do
    pending
  end

end
