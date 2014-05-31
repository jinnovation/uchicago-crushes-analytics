require 'spec_helper'

describe "crushes/index" do
  before(:each) do
    assign(:crushes, [
      stub_model(Crush),
      stub_model(Crush)
    ])
  end

  it "renders a list of crushes" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
