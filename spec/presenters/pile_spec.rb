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
end
