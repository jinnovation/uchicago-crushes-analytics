require 'spec_helper'

describe "Sidebar" do
  before :each do
    visit root_path
  end

  let(:sidebar_id) { "#sidebar" }
  let(:sidebar) { find sidebar_id }
  let(:sidebar_link_user) { sidebar.find "#sidebar-users-link" }
  let(:sidebar_link_post) { sidebar.find "#sidebar-posts-link"}
  let(:sidebar_link_analytics) { sidebar.find "#sidebar-analytics-link" }

  describe "#Users" do
    it "redirects to User#index" do
      sidebar_link_user.click

      expect(current_path).to eq users_path
    end

    describe "#Posts" do
      it "redirects to Post#index" do
        sidebar_link_post.click

        expect(current_path).to eq posts_path
      end
    end

    describe "#Analytics" do
      it "does not redirect" do
        sidebar_link_analytics.click

        expect(current_path).to eq root_path
      end
    end
  end
end
