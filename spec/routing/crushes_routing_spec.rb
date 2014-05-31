require "spec_helper"

describe CrushesController do
  describe "routing" do

    it "routes to #index" do
      get("/crushes").should route_to("crushes#index")
    end

    it "routes to #new" do
      get("/crushes/new").should route_to("crushes#new")
    end

    it "routes to #show" do
      get("/crushes/1").should route_to("crushes#show", :id => "1")
    end

    it "routes to #edit" do
      get("/crushes/1/edit").should route_to("crushes#edit", :id => "1")
    end

    it "routes to #create" do
      post("/crushes").should route_to("crushes#create")
    end

    it "routes to #update" do
      put("/crushes/1").should route_to("crushes#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/crushes/1").should route_to("crushes#destroy", :id => "1")
    end

  end
end
