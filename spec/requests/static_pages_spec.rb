require 'spec_helper'

describe "Static pages" do
  subject { page }

  shared_examples_for "all static pages" do
    describe "should have a header" do
      describe "with a navbar" do
        it { should have_selector "nav" }
      end
    end

    describe "should have a footer" do
      it { should have_selector "footer" }
    end
  end
  
  describe "Home page" do
    before { visit root_path }

    it_should_behave_like "all static pages"
    
    it { should have_content APP_NAME }

    describe "dashboard" do
      describe "has an Actions pane" do
        pending
      end

      describe "has a Metrics pane" do
        pending
      end

      describe "Latest Crush Breakdown pane" do
        describe "displays the newest Post" do
          pending
        end
      end
    end

    describe "user listing" do
      pending
    end

    describe "crush listing" do
      pending
    end
  end
end
