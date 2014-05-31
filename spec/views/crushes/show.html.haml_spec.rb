require 'spec_helper'

describe "crushes/show" do
  before(:each) do
    @crush = assign(:crush, stub_model(Crush))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
