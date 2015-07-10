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
  let(:suit) { "hearts" }
  let(:rank) { "queen" }
  let(:card) { Card.new(rank: rank, suit: suit) }

  context "when comparing to cards of matching suit and rank" do
    let(:matching_card) { Card.new(suit: suit, rank: rank) }

    it "can be saved" do
      card.save!
    end

    it "shows both cards are equal" do
      expect(matching_card == card).to be true
    end

    it "gives both cards the same hash" do
      expect(matching_card.hash).to eq card.hash
    end
  end

  context "cards with different suit and rank" do
    let(:card1) { Card.new(suit: Card::SUITS.first, rank: Card::RANKS.first) }
    let(:card2) { Card.new(suit: Card::SUITS.last, rank: Card::RANKS.last) }

    it "shows both cards are different" do
      expect(card1 == card2).to be false
    end
  end

  context "when initializing" do

    context "with correct suit and rank" do
      it "is #valid?" do
        expect(card).to be_valid
      end

      it "can save" do
        card.save!
      end
    end

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
