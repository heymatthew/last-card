require 'rails_helper'

RSpec.shared_examples "an invalid Card" do
  context "once saved" do
    it "is not #valid?" do
      expect(card).to_not be_valid
    end

    it "has errors" do
      expect { card.valid? }
        .to change { card.errors.size }
        .from(0)
    end
  end
end

RSpec.describe Card, type: :model do
  #let(:card) { Card.first } TODO ????
  let(:suit) { "hearts" }
  let(:rank) { "queen" }
  let(:card) { Card.new(rank: rank, suit: suit) }

  context "when initializing" do
    context "without parameters" do
      let(:card) { Card.new }
      it_behaves_like "an invalid Card"
    end

    context "missing suit" do
      let(:suit) { nil }
      it_behaves_like "an invalid Card"
    end

    context "missing rank" do
      let(:rank) { nil }
      it_behaves_like "an invalid Card"
    end

    context "with invalid suit" do
      let(:suit) { "dude bro party massacre 3" }
      it_behaves_like "an invalid Card"
    end

    context "with invalid rank" do
      let(:rank) { "kung fury" }
      it_behaves_like "an invalid Card"
    end
  end
end
