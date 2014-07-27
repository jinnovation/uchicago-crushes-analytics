require 'spec_helper'
describe "Home Page" do
  before :each do
    visit root_path
  end

  context "Latest Users pane" do
    before :each do
      @users = create_list :user, 30

      @users.each_with_index do |user, n|
        n.times do |m|
          create :crush, user: user
        end
      end

      visit root_path
    end

    let(:user_table_id) { "#user-table" }
    let(:user_table) { find user_table_id }
    let(:user_table_rows) { user_table.all "tr" }

    context "Users table" do
      it "displays 30 Users" do
        expect(user_table_rows.size).to eq 30
      end

      it "is sorted by #num_crushes" do
        user_names_display = user_table_rows.map do |row|
          row.find(".user-name").text
        end

        user_names_actual = User.select_most_crushes(30).map do |user|
          user.full_name
        end

        expect(user_names_display).to eq user_names_actual
      end
    end
  end

  context "Latest Posts pane" do
    before :each do
      @posts = create_list :post, 30

      visit root_path
    end

    let(:post_table_id) { "#post-table" }
    let(:post_table) { find post_table_id }
    let(:post_table_rows) { post_table.all "tr" }

    context "Posts table" do
      it "displays 25 Posts" do
        expect(post_table_rows.size).to eq 25
      end

      it "is sorted by datetime" do
        post_times_display = post_table_rows.map do |row|
          row.find(".post-time").text.squish
        end

        post_times_actual = Post.latest(25).map do |post|
          post.fb_created_time.strftime(Post::TIME_DISP_FMT).squish
        end

        expect(post_times_display).to eq post_times_actual
      end

      describe "row" do
        let(:post_entry) { post_table_rows.first }
        it "links to Post#show", js: true do
          post_content = post_entry.find(".post-content").text
          path_expected = post_path Post.find_by_content post_content

          post_entry.click

          expect(current_path).to eq path_expected
        end
      end
    end

  end
end

