require 'spec_helper'

describe "crushes/new" do
  before(:each) do
    assign(:crush, stub_model(Crush).as_new_record)
  end

  it "renders new crush form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", crushes_path, "post" do
    end
  end
end
