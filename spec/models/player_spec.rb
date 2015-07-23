require 'rails_helper'
require_relative 'shared_examples'

RSpec.shared_examples "an invalid Player" do
  let(:model) { player }
  include_examples "an invalid ActiveRecord"
end

RSpec.describe Player, type: :model do
  let(:nickname) { "flubber123" }
  let(:player)   { Player.new(nickname: nickname) }

  context "with alphanumeric nickname" do
    it "is #valid?" do
      expect(player).to be_valid
    end
  end

  context "with space in name" do
    let(:nickname) { "1337 haxor" }
    it_behaves_like "an invalid Player"
  end

  context "with punctuation in the name" do
    let(:nickname) { "haxor!" }
    it_behaves_like "an invalid Player"
  end

  context "dropping a newline at the start" do
    let(:nickname) { "\nhaxor" }
    it_behaves_like "an invalid Player"
  end

  context "dropping a newline at the end" do
    let(:nickname) { "haxor\n" }
    it_behaves_like "an invalid Player"
  end

  context "when there is contentsion over a nickname" do
    before { Player.create!(nickname: nickname) }
    it_behaves_like "an invalid Player"
  end

  context "when interacting with the game" do
    let(:game) { Game.create! }
    let(:card) { Card.deck.first }

    before { player.save }

    context "picking up" do
      subject { player.pickup!(game,card) }

      it "adds to player pickups" do
        expect { subject }.to change { player.pickups.count }.by(1)
      end

      it "does not change player plays" do
        expect { subject }.not_to change { player.plays.count }
      end
    end

    context "playing" do
      subject{ player.play!(game, card) }

      it "adds to player plays" do
        expect { subject }.to change { player.plays.count }.by(1)
      end

      it "to not change player pickups" do
        expect { subject }.not_to change { player.pickups.count }
      end
    end
  end
end
