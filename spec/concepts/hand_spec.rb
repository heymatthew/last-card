require 'rails_helper'

RSpec.shared_examples "chainable methods" do
  context "when called" do
    it "returns another Hand" do
      expect(subject).to be_a_kind_of Hand
    end
  end
end

RSpec.describe Hand do
  let(:cards) do
    [ Card.new('queen','hearts'),
      Card.new('ace','spades'),
      Card.new('queen','spades') ]
  end

  let(:hand) { Hand.new(cards) }

  context "when filtering on spades" do
    subject { hand.filter_suit('spades') }

    it_behaves_like "chainable methods"

    it "only returns spades" do
      expect(subject.first.suit).to eq 'spades'
      suits = subject.map(&:suit)
      expect(suits.uniq.count).to be 1
    end
  end

  context "when filtering on queens" do
    subject { hand.filter_rank('queen') }

    it_behaves_like "chainable methods"

    it "only returns queens" do
      expect(subject.first.rank).to eq 'queen'
      ranks = subject.map(&:rank)
      expect(ranks.uniq.count).to be 1
    end
  end

end
