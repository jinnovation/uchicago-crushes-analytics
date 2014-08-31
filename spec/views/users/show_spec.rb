require 'spec_helper'

describe "Users show" do
  before :each do
    @user = create :user

    visit user_path(@user)
  end

  it "displays User#full_name" do
    expect(page).to have_content @user.full_name
  end

  feature "Crush panel" do
    it "is displayed" do
      expect(page).to have_selector "#user-crushes-panel"
    end

    feature "Crush table" do
      before :each do
        create_list :crush, 10, user: @user

        visit user_path(@user)
      end
      
      let(:table_id) { "#user-crushes-table" }
      let(:table) { find table_id }
      let(:table_rows) { table.find("tbody").all("tr") }
      let(:table_row) { table_rows.first }

      context "when User has Crushes about him/her" do
        it "is displayed" do
          expect(page).to have_selector table_id
        end

        it "displays all User#crushes" do
          expect(table_rows.size).to eq @user.num_crushes
        end

        it "is sorted by Datetime" do
          post_times = table_rows.map do |row|
            DateTime.strptime row.find(".post-time").text, Post::TIME_DISP_FMT
          end

          binding.pry
          expect(post_times.sort).to eq post_times
        end

        context "User crush entry" do
          before :each do
            @test_post = @user.latest_post
          end

          it "displays the date that Post was made" do
            expect(table_row.text).to have_content @test_post.time_display
          end

          it "displays at least part of Post content" do
            display_content = @test_post.content.split.first(3).join(" ")

            expect(table_row.text).to have_content display_content
          end

          it "truncates excessively long Post contents" do
            recent_post = create :post, :long, fb_created_time: Time.now
            visit user_path(@user)

            expect(recent_post.content).to include table_row.find(".post-content").text
            expect(table_row.find(".content")).to include "..."

            recent_post.destroy
          end
        end
      end                       # context when User has Crushes about him/her
    end
  end
end

