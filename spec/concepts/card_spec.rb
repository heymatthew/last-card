require 'rails_helper'

RSpec.shared_examples "does not block" do
  it "does not block" do
    expect(card).to_not be_block
  end
end

RSpec.shared_examples "does not skip" do
  it "does not skip" do
    expect(card).to_not be_skip
  end
end

RSpec.shared_examples "has no pickups" do
  it "has no pickups" do
    expect(card.pickup_count).to be 0
    expect(card).to_not be_pickup
  end
end

RSpec.shared_examples "is playable" do
  it "is #playable_on? other card" do
    expect(next_card).to be_playable_on(current_card)
  end
end

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

  context "when card is not fancy" do
    let(:rank) { 'hearts' }
    include_examples "has no pickups"
    include_examples "does not skip"
    include_examples "does not block"
  end

  context "when card is a 10" do
    let(:rank) { '10' }
    include_examples "has no pickups"
    include_examples "does not block"

    it "skips" do
      expect(card).to be_skip
    end
  end

  context "when card is a 2" do
    let(:rank) { "2" }
    include_examples "does not block"
    include_examples "does not skip"

    it "makes you pickup" do
      expect(card.pickup_count).to be 2
      expect(card).to be_pickup
    end
  end

  context "when card is a 5" do
    let(:rank) { "5" }
    include_examples "does not block"
    include_examples "does not skip"

    it "makes you pickup" do
      expect(card.pickup_count).to be 5
      expect(card).to be_pickup
    end
  end

  context "when card is an ace" do
    let(:rank) { 'ace' }
    include_examples "has no pickups"
    include_examples "does not block"
    include_examples "does not skip"

    # TODO need to allow this to be played on all other suits
    # TODO player sets the suit
  end

  context "checking playability against other cards" do
    let(:suit) { "hearts" }
    let(:rank) { "queen" }
    let(:current_card) { Card.new(rank, suit) }

    let(:next_suit) { "5" }
    let(:next_rank) { "diamonds" }
    let(:next_card) { Card.new(next_rank, next_suit) }

    it "is not #playable_on? other card of different rank and suit" do
      expect(next_card).to_not be_playable_on(current_card)
    end

    context "given card is the same suit" do
      let(:next_suit) { suit }
      include_examples "is playable"
    end

    context "given card is the same rank" do
      let(:next_rank) { rank }
      include_examples "is playable"
    end

    context "given card is an ace" do
      let(:next_rank) { 'ace' }
      include_examples "is playable"
    end

    # TODO context "when card is played on an ace" (and player has set suit)
  end
end
