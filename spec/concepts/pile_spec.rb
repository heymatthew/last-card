require 'rails_helper'

RSpec.describe Pile do
  let(:cards) do
    [ Card.new('queen','hearts'),
      Card.new('ace','spades'),
      Card.new('queen','hearts') ]
  end

  let(:pile) { Pile.new(cards) }

  it "shows the last card on top" do
    expect(pile.top).to be cards.last
  end

  context "when no pickups on top of deck" do
    it "has 0 pickups" do
      expect(pile.pickup_count).to be 0
    end
  end

  context "when a 5 is on the top of the pile" do
    before { pile.push(Card.new("5", "dimonds")) }

    it "has 5 pickups" do
      expect(pile.pickup_count).to be 5
    end
  end

  context "when a 2 is played on a 5" do
    before do
      pile.push(Card.new("5", "dimonds"))
      pile.push(Card.new("2", "dimonds"))
    end

    it "has 7 pickups" do
      expect(pile.pickup_count).to be 7
    end
  end
end
