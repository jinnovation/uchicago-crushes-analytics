require 'spec_helper'

describe "Static pages" do
  subject { page }

  shared_examples_for "all static pages" do
    describe "should have a header" do
      pending
    end

    describe "should have a footer" do
      pending
    end
  end
  
  describe "Home page" do
    before { visit root_path }

    it_should_behave_like "all static pages"
    
    it { should have_content APP_NAME }

    describe "dashboard" do
      pending
    end

    describe "user listing" do
      pending
    end

    describe "crush listing" do
      pending
    end
  end
end
