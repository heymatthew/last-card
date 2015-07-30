require 'rails_helper'
require_relative 'shared_examples'

RSpec.shared_examples "an invalid Player" do
  let(:model) { player }
  include_examples "an invalid ActiveRecord"
end

RSpec.describe Player, type: :model do
  let(:user)     { User.create!(nickname: "flipper") }
  let(:game)     { Game.create! }

  let(:player) { user.players.create!(game: game) }
  let(:card)   { Card::DECK.first }

  context "when interacting with the game" do
    context "picking up" do
      subject { player.pickup!(card) }

      it "adds to player pickups" do
        expect { subject }.to change { player.pickups.count }.by(1)
      end

      it "does not change player plays" do
        expect { subject }.not_to change { player.plays.count }
      end
    end

    context "playing" do
      subject{ player.play!(card) }

      it "adds to player plays" do
        expect { subject }.to change { player.plays.count }.by(1)
      end

      it "to not change player pickups" do
        expect { subject }.not_to change { player.pickups.count }
      end
    end
  end
end
