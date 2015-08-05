require 'rails_helper'

RSpec.describe Deck do
  let(:cards) do
    [ Card.new('queen','hearts'),
      Card.new('ace','spades'),
      Card.new('queen','diamonds') ]
  end

  let(:deck) { Deck.new(cards) }

  it "removes cards from the deck" do
    expect { deck.pickup }.to change { deck.count }.by(-1)
  end

  it "no longer contains removed card" do
    card = deck.pickup
    expect(deck).to_not include(card)
  end
end
