require 'spec_helper'
require 'shared_examples'

describe Crush do
  before do
    @user   = FactoryGirl.create :user
    @user1  = FactoryGirl.create :user

    @post   = FactoryGirl.create :post, content: @user.full_name + " " + Faker::Lorem.paragraph(4)

    @crush  = FactoryGirl.create :crush, user_id: @user.id,  post_id: @post.id,
    num_tags: 4
    @crush1 = FactoryGirl.create :crush, user_id: @user1.id, post_id: @post.id,
    num_tags: 6

    @post.quotients_calc

    @crush.reload
    @crush1.reload
  end

  context "in general" do


    it "should have the requisite attributes" do
      expect(@crush).to respond_to :user_id
      expect(@crush).to respond_to :post_id
      expect(@crush).to respond_to :num_tags
      expect(@crush).to respond_to :quotient
      expect(@crush).to respond_to :last_tag_time
      expect(@crush).to respond_to :user
      expect(@crush).to respond_to :post
    end

    it "should be valid" do
      expect(@crush).to be_valid
    end

    describe :user_id do
      subject { @crush.user_id }
      it_behaves_like "table entry"
    end

    describe "without user_id" do
      before { @crush.user_id = nil }
      it { should_not be_valid }
    end

    describe :post_id do
      subject { @crush.post_id }
      it_behaves_like "table entry"
    end

    describe "without post_id" do
      before { @crush.post_id = nil }
      it { should_not be_valid }
    end

    describe :last_tag_time do
      subject { @crush.last_tag_time }
      it_behaves_like "table entry"
    end

    describe :quotient do
      it "should be >=0.0 and <=1.0" do
        expect(@crush.quotient).to be <= 1.0
        expect(@crush.quotient).to be >= 0.0
      end
    end

    describe :num_tags do
      subject { @crush.num_tags }
      it_behaves_like "table entry"
      it_behaves_like "positive integer"

      describe "when <= 0" do
        subject { @crush }

        before { @crush.num_tags = 0 }
        it { should_not be_valid }

        before { @crush.num_tags = -1 }
        it { should_not be_valid }
      end
    end
  end

  context "in reference to Users and Posts" do
    before do

      @post   = FactoryGirl.create :post, content: @user.full_name + " " + Faker::Lorem.paragraph(4)

      @crush  = FactoryGirl.create :crush, user_id: @user.id,  post_id: @post.id,
      num_tags: 4
      @crush1 = FactoryGirl.create :crush, user_id: @user1.id, post_id: @post.id,
      num_tags: 6

      @post.quotients_calc

      @crush.reload
      @crush1.reload
    end

    it "should reference the correct post" do
      expect(@crush.post).to eq @post
    end

    describe "with duplicate user_id and post_id" do
      before do
        @crush.user_id = @crush1.user_id
        @crush.post_id = @crush1.post_id
      end
      subject { @crush }
      it { should_not be_valid }
    end
  end


  context "contains a User.full_name" do
    context "that only belongs to a single tagged user" do
      it "should have the right Crush.quotients" do
        expect(@crush.quotient).to eq 1.0
        expect(@crush1.quotient).to eq 0.0
      end
    end

    context "that belongs to both tagged users" do
      before do
        @user_clone  = FactoryGirl.create :user, first_name: @user.first_name,
        last_name: @user.last_name

        @post   = FactoryGirl.create :post, content: @user.full_name + " " + Faker::Lorem.paragraph(4)

        @crush  = FactoryGirl.create :crush, user_id: @user.id,  post_id: @post.id, num_tags: 4
        @crush1 = FactoryGirl.create :crush, user_id: @user_clone.id, post_id: @post.id, num_tags: 6

        @post.quotients_calc

        @crush.reload
        @crush1.reload
      end

      it "should have the right Crush.quotients" do
        expect(@crush.quotient).to eq 0.4
        expect(@crush1.quotient).to eq 0.6
      end
    end

  end

  context "contains a User.first_name" do
    pending
  end

  context "contains a User.last_name" do
    pending
  end

end
