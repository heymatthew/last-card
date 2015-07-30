require 'rails_helper'
require_relative 'shared_examples'

RSpec.shared_examples "an invalid Action" do
  let(:model) { action }
  include_examples "an invalid ActiveRecord"
end

RSpec.describe Action, type: :model do
  let(:rank)   { Card::RANKS.first }
  let(:suit)   { Card::SUITS.first }
  let(:game)   { Game.create!     }
  let(:effect) { Action::PICKUP   }
  let(:user)   { User.create!(nickname: "mctesterson") }
  let(:player) { user.players.create!(game: game) }

  let(:action) do
    Action.new(
      card_suit: suit,
      card_rank: rank,
      player: player,
      effect: effect,
    )
  end

  context "when initializing" do
    context "with a player and a card" do
      it "is #valid?" do
        expect(action).to be_valid
      end

      it "can save" do
        action.save!
      end
    end

    context "with no parameters" do
      let(:action) { Action.new }
      it_behaves_like "an invalid Action"
    end

    context "without a player" do
      let(:player) { nil }
      it_behaves_like "an invalid Action"
    end

    context "without an effect" do
      let(:effect) { nil }
      it_behaves_like "an invalid Action"
    end

    context "without a rank" do
      let(:rank) { nil }
      it_behaves_like "an invalid Action"
    end

    context "without a suit" do
      let(:suit) { nil }
      it_behaves_like "an invalid Action"
    end

    context "with invalid suit" do
      let(:suit) { "dude bro party massacre 3" }
      it_behaves_like "an invalid Action"
    end

    context "with invalid rank" do
      let(:rank) { "kung fury" }
      it_behaves_like "an invalid Action"
    end
  end

  context "multiple actions" do
    it "can save references to the same card" do
      2.times do
        Action.create!(
          card_suit: suit,
          card_rank: rank,
          player: player,
          effect: effect,
        )
      end
    end
  end
end
