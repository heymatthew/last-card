require 'rails_helper'
require_relative 'shared_examples'

RSpec.shared_examples "an invalid Action" do
  let(:model) { action }
  include_examples "an invalid ActiveRecord"
end

RSpec.describe Action, type: :model do
  fixtures :cards

  let(:card)   { Card.first     }
  let(:game)   { Game.create!   }
  let(:effect) { Action::PICKUP }
  let(:user)   { User.create!(nickname: "mctesterson") }
  let(:player) { user.players.create!(game: game) }

  let(:action) do
    Action.new(
      card: card,
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

    context "without a card" do
      let(:card) { nil }
      it_behaves_like "an invalid Action"
    end
  end

  context "multiple actions" do
    it "can save references to the same card" do
      2.times do
        Action.create!(
          card:   card,
          player: player,
          effect: effect,
        )
      end
    end
  end
end
