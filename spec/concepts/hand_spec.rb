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
      Card.new('4','spades'),
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

  describe "#select_playable" do
    # TODO when top card has been played as an ace
    context "when top card doesn't share suit or rank" do
      subject { hand.select_playable(Card.new('3', 'diamonds')) }

      it "returns no playable cards" do
        expect(subject.size).to be 0
      end
    end

    context "when top card shares suit" do
      subject { hand.select_playable(Card.new('3', 'spades')) }

      it "returns spades" do
        expect(subject).to include Card.new('4', 'spades')
      end

      it "leaves behind other suits" do
        expect(subject).to_not include Card.new('queen', 'hearts')
      end
    end

    context "when top card shares rank" do
      subject { hand.select_playable(Card.new('queen', 'diamonds')) }

      it "returns queens" do
        expect(subject).to include Card.new('queen', 'spades')
      end

      it "leaves out other cards" do
        expect(subject).to_not include Card.new('4', 'spades')
      end
    end
  end
end
