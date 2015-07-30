require 'rails_helper'

RSpec.describe Card, type: :model do
  let(:suit) { "hearts" }
  let(:rank) { "queen" }
  let(:card) { Card.new(rank, suit) }

  describe "#to_s" do
    context "for face cards" do
      it "uses sentence case on suit and rank" do
        expect(card.to_s).to eq "Queen of Hearts"
      end
    end

    context "for pips" do
      let(:rank) { "2" }
      it "only upcases the rank" do
        expect(card.to_s).to eq "2 of Hearts"
      end
    end
  end
end
