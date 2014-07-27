require 'spec_helper'
describe "Home Page" do
  before :each do
    visit root_path
  end

  context "Latest Users pane" do
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
        expect(post_table_rows.size).to be == 25
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
    end

  end
end

