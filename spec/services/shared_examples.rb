# To use this, just include it :)
RSpec.shared_examples "a service with errors" do
  context "when called" do
    it "bails" do
      expect(service.call).to be false
    end

    it "gives errors" do
      expect { service.call }.to change { service.errors.size }.from(0)
    end
  end
end
