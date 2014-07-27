require 'spec_helper'

describe "Sidebar" do
  before :each do
    visit root_path
  end

  let(:sidebar_id) { "#sidebar" }
  let(:sidebar) { find sidebar_id }

  describe "#Users" do
    it "redirects to User#index" do
    end

    describe "#Posts" do
      it "redirects to Post#index"
    end

    describe "#Analytics" do
      it "does not redirect"
    end
  end
end
