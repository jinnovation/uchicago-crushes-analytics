require 'spec_helper'

describe Crush do
  before do
    @crush = Crush.new(user_id: 1, post_id: 1, num_tags: 1, quotient: 0.87)
  end

  subject { @crush }
  
  it { should respond_to :user_id }
  it { should respond_to :post_id }
  it { should respond_to :num_tags }
  it { should respond_to :quotient }

  it { should be_valid }

  describe "when user_id is not present" do
    before { @crush.user_id = nil }
    it { should_not be_valid }
  end

  describe "when post_id is not present" do
    before { @crush.post_id = nil }
    it { should_not be_valid }
  end

  describe "when num_tags == 0" do
    before { @crush.num_tags = 0 }
    it { should_not be_valid }
  end

  it "should not have multiple for a single user" do
    pending
  end
end
