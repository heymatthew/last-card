require 'rails_helper'
require_relative 'shared_examples'

RSpec.shared_examples "an invalid Player" do
  let(:model) { player }
  include_examples "an invalid ActiveRecord"
end

RSpec.describe Player, type: :model do
  let(:nick)   { "flubber123" }
  let(:player) { Player.new(nick: nick) }

  context "with alphanumeric nick" do
    it "is #valid?" do
      expect(player).to be_valid
    end
  end

  context "with space in name" do
    let(:nick) { "1337 haxor" }
    it_behaves_like "an invalid Player"
  end

  context "with punctuation in the name" do
    let(:nick) { "haxor!" }
    it_behaves_like "an invalid Player"
  end

  context "dropping a newline at the start" do
    let(:nick) { "\nhaxor" }
    it_behaves_like "an invalid Player"
  end

  context "dropping a newline at the end" do
    let(:nick) { "haxor\n" }
    it_behaves_like "an invalid Player"
  end

  context "when there is contentsion over a nick" do
    before { Player.create!(nick: nick) }
    it_behaves_like "an invalid Player"
  end

  context "when interacting with the game" do
    let(:game) { Game.create! }
    let(:card) { Card.deck.first }

    before { player.save }

    context "picking up" do
      it "adds to player pickups" do
        expect { player.pickup(game,card) }.to change { player.pickups.count }.by(1)
      end

      it "does not change player plays" do
        expect { player.pickup(game,card) }.not_to change { player.plays.count }
      end
    end

    context "playing" do
      it "adds to player plays" do
        expect { player.play(game,card) }.to change { player.plays.count }.by(1)
      end

      it "to not change player pickups" do
        expect { player.play(game,card) }.not_to change { player.pickups.count }
      end
    end
  end
end
