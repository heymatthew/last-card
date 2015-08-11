# To use this, just include it :)
RSpec.shared_examples "invalid ActiveModel" do
  it "is not #valid?" do
    expect(model).to_not be_valid
  end

  it "has errors" do
    expect { model.valid? }
      .to change { model.errors.size }
      .from(0)
  end
end
