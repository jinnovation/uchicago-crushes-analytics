require 'spec_helper'

describe "Users show" do
  before :each do
    @user = create :user
    create_list :crush, 10, user: @user

    visit user_path(@user)
  end

  it "displays User#full_name" do
    expect(page).to have_content @user.full_name
  end

  it "displays User#num_crushes" do
    expect(page).to have_content "10 crushes"
  end

  feature "Crush panel" do
    it "is displayed" do
      expect(page).to have_selector "#user-crushes-panel"
    end

    feature "Crush table" do
      let(:table_id) { "#user-crushes-table" }
      context "when User has Crushes about him/her" do
        it "is displayed" do
          expect(page).to have_selector table_id
        end
      end                       # context when User has Crushes about him/her
    end
  end
end

