require 'rails_helper'

RSpec.shared_examples "an invalid Action" do
  # FIXME generalise as "an invalid ActiveRecord"
  # problem: let wont pass into it_behaves_like blocks
  # possibly let(:model) something something
  context "once saved" do
    it "is not #valid?" do
      expect(action).to_not be_valid
    end

    it "has errors" do
      expect { action.valid? }
        .to change { action.errors.size }
        .from(0)
    end
  end
end

RSpec.describe Action, type: :model do
  context "when initializing" do
    let(:card)   { Card.create!(rank: "queen", suit: "hearts") }
    let(:game)   { Game.create!   }
    let(:affect) { Action::PICKUP }
    let(:player) { Player.create! }

    let(:action) do
      Action.new(
        card:   card,
        player: player,
        game:   game,
        affect: affect,
      )
    end

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

    context "without a game" do
      let(:game) { nil }
      it_behaves_like "an invalid Action"
    end

    context "without an affect" do
      let(:affect) { nil }
      it_behaves_like "an invalid Action"
    end

    context "without a card" do
      let(:card) { nil }
      it_behaves_like "an invalid Action"
    end
  end
end
