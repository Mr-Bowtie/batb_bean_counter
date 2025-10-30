require "rails_helper"

RSpec.describe PayPeriodBreakdownsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/pay_period_breakdowns").to route_to("pay_period_breakdowns#index")
    end

    it "routes to #new" do
      expect(get: "/pay_period_breakdowns/new").to route_to("pay_period_breakdowns#new")
    end

    it "routes to #show" do
      expect(get: "/pay_period_breakdowns/1").to route_to("pay_period_breakdowns#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/pay_period_breakdowns/1/edit").to route_to("pay_period_breakdowns#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/pay_period_breakdowns").to route_to("pay_period_breakdowns#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/pay_period_breakdowns/1").to route_to("pay_period_breakdowns#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/pay_period_breakdowns/1").to route_to("pay_period_breakdowns#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/pay_period_breakdowns/1").to route_to("pay_period_breakdowns#destroy", id: "1")
    end
  end
end
