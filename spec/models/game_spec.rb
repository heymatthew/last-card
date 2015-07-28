require 'rails_helper'

RSpec.describe Game, type: :model do
  let(:game) { Game.create! }
  let(:user1) { User.create!(nickname: "batman") }
  let(:user2) { User.create!(nickname: "tothemax") }

  context "when fewer than 2 users" do
    before do
      game.users << user1
      game.save
    end

    it "is not #ready? to start" do
      expect(game).to_not be_ready
    end
  end

  context "with 2 users" do
    before do
      game.users << user1
      game.users << user2
      game.save
    end

    it "to be #ready?" do
      expect(game).to be_ready
    end

    context "after game started" do
      before { game.pending = false }

      it "has #started?" do
        expect(game).to be_started
      end
    end
  end

  context "after action" do
    let(:card) { Card.find_by(rank: "queen", suit: "hearts") }

    describe "user#play" do
      subject { user1.play!(game, card) }

      it "shows up in game#plays" do
        expect { subject }.to change { game.plays.size }.by(1)
      end

      it "doesn't affect game#pickups" do
        expect { subject }.to_not change { game.pickups }
      end
    end

    describe "user#pickup" do
      subject { user1.pickup!(game, card) }

      it "shows up in game#pickups" do
        expect { subject }.to change { game.pickups.size }.by(1)
      end

      it "doesn't affect game#plays" do
        expect { subject }.to_not change { game.plays }
      end
    end
  end
end
