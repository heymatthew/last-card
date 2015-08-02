require 'rails_helper'

RSpec.shared_examples "is not blocky" do
  it "is not blocky" do
    expect(card).to_not be_blocky
  end
end

RSpec.shared_examples "is not skippy" do
  it "is not skippy" do
    expect(card).to_not be_skippy
  end
end

RSpec.shared_examples "has no pickups" do
  it "has no pickups" do
    expect(card.pickup).to be_nil
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
    include_examples "is not skippy"
    include_examples "is not blocky"
  end

  context "when card is a 10" do
    let(:rank) { '10' }
    include_examples "has no pickups"
    include_examples "is not blocky"

    it "skips" do
      expect(card).to be_skippy
    end
  end

  context "when card is a 2" do
    let(:rank) { "2" }
    include_examples "is not blocky"
    include_examples "is not skippy"

    it "makes you pickup" do
      expect(card.pickup).to be 2
    end
  end

  context "when card is a 5" do
    let(:rank) { "5" }
    include_examples "is not blocky"
    include_examples "is not skippy"

    it "makes you pickup" do
      expect(card.pickup).to be 5
    end
  end

  context "when card is an ace" do
    let(:rank) { 'ace' }
    include_examples "has no pickups"
    include_examples "is not blocky"
    include_examples "is not skippy"

    # TODO need to allow this to be played on all other suits
    # TODO player sets the suit
  end
end
