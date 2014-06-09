require 'spec_helper'
require 'shared_examples'

describe Crush do
  before do
    @user   = FactoryGirl.create :user
    @user1  = FactoryGirl.create :user

    @post   = FactoryGirl.create :post
    @post1  = FactoryGirl.create :post

    @crush  = FactoryGirl.create :crush, user_id: @user.id, post_id: @post.id
    @crush1 = FactoryGirl.create :crush, user_id: @user1.id, post_id: @post1.id
  end

  subject { @crush }
  
  it { should respond_to :user_id }
  it { should respond_to :post_id }
  it { should respond_to :num_tags }
  it { should respond_to :quotient }
  it { should respond_to :last_tag_time }

  it { should respond_to :quotient_calc }

  it { should be_valid }

  describe :user_id do
    it_behaves_like "table entry"
  end

  describe :post_id do
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

  describe :num_tags do
    it_behaves_like "table entry"

    subject { @crush.num_tags }
    it_behaves_like "positive integer"

    describe "when <= 0" do
      subject { @crush }
      
      before { @crush.num_tags = 0 }
      it { should_not be_valid }

      before { @crush.num_tags = -1 }
      it { should_not be_valid }
    end
  end

  describe "with duplicate user_id and post_id" do
    before do
      @crush.user_id = @crush1.user_id
      @crush.post_id = @crush1.post_id
    end
    it { should_not be_valid }
  end
  
end
