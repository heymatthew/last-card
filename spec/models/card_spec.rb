require 'rails_helper'
require_relative 'shared_examples'

RSpec.shared_examples "an invalid Card" do
  let(:model) { card }
  include_examples "an invalid ActiveRecord"
end

RSpec.describe Card, type: :model do
  let(:suit) { "hearts" }
  let(:rank) { "queen" }
  let(:card) { Card.new(rank: rank, suit: suit) }

  context "initializing" do
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

  describe "#to_s" do
    context "for face cards" do
      it "uses sentence case on suit and rank" do
        expect(card.to_s).to eq "Queen of Hearts"
      end
    end

    context "for pips" do
      let(:rank) { 2 }
      it "only upcases the rank" do
        expect(card.to_s).to eq "2 of Hearts"
      end
    end
  end
end
