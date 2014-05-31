require 'spec_helper'

describe "crushes/edit" do
  before(:each) do
    @crush = assign(:crush, stub_model(Crush))
  end

  it "renders the edit crush form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", crush_path(@crush), "post" do
    end
  end
end
