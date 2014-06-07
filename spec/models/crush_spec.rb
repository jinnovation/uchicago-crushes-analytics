require 'spec_helper'
require 'shared_examples'

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

  describe "user_id" do
    subject { @crush.user_id }    
    it_behaves_like "table entry"
  end

  describe "post_id" do
    subject { @crush.post_id }
    it_behaves_like "table entry"
  end

  describe "without user_id" do
    before { @crush.user_id = nil }
    it { should_not be_valid }
  end

  describe "without post_id" do
    before { @crush.post_id = nil }
    it { should_not be_valid }
  end

  describe "without {user,post}_id" do
    before do
      @crush.post_id = nil
      @crush.user_id = nil
    end

    it { should_not be_valid }
  end

  describe "num_tags" do
    subject { @crush.num_tags }
    it_behaves_like "table entry"
    it_behaves_like "positive integer"
  end

  describe "when it has the same user_id and post_id as another Crush" do
    before do
      @crush_dup_ids = Crush.new(user_id: 1, post_id: 1, num_tags: 5, quotient: 0.2)
    end

    subject { @crush_dup_ids }
    
    it { should_not be_valid }
  end
  
end
