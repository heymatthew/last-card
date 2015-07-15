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
end
