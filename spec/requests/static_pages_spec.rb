require 'spec_helper'

describe "Static pages" do
  subject { page }
  
  describe "Home page" do
    before { visit root_path }

    it_should_behave_like "all static pages"
    
    it { should have_content APP_NAME }

    describe "dashboard" do
      describe "has an Actions pane" do
        describe "with a search bar" do
          pending
        end

        describe "with a 'Submit to UChicago Crushes' button" do
          # it { should have_selector "button", text: Strings::CRUSH_SUBMIT }
        end
      end

      describe "has a Metrics pane" do
        pending
      end

      describe "Latest Crush Breakdown pane" do
        describe "that displays the latest Post" do
          pending
        end
      end
    end

    describe "user listings" do
      describe "display users'" do
        describe "full names" do
          pending
        end
        
        describe "profile pictures" do
          pending
        end

        describe "number of crushes" do
          pending
        end
      end
    end

    describe "post listings" do
      describe "display posts'" do
        describe "truncated content" do
          
        end

        describe "highest-scoring User's" do
          describe "profile picture" do
            
          end

          describe "quotient for that post" do
            
          end
        end
      end
    end
    
  end
end
