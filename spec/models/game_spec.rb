require 'rails_helper'

RSpec.describe Game, type: :model do
  let(:game) { Game.create! }
  let(:user) { User.create!(nickname: "batman") }
  let(:player1) { user.players.build }
  let(:player2) { user.players.build }

  # TODO validation against players joining a game twice

  context "when fewer than 2 players" do
    before do
      game.players << player1
      game.save!
    end

    it "is not #ready? to start" do
      expect(game).to_not be_ready
    end
  end

  context "with 2 players" do
    before do
      game.players << player1
      game.players << player2
      game.save!
    end

    it "to be #ready?" do
      expect(game).to be_ready
    end

    context "after game started" do
      before { game.pending = false }

      it "has #started?" do
        expect(game).to be_started
      end

      context "after action" do
        let(:card) { Card.new("queen", "hearts") }

        describe "player#play" do
          subject { player1.play!(card) }

          it "shows up in game#plays" do
            expect { subject }.to change { game.plays.size }.by(1)
          end

          it "doesn't change game#pickups" do
            expect { subject }.to_not change { game.pickups }
          end
        end

        describe "player#pickup" do
          subject { player1.pickup!(card) }

          it "shows up in game#pickups" do
            expect { subject }.to change { game.pickups.size }.by(1)
          end

          it "doesn't change game#plays" do
            expect { subject }.to_not change { game.plays }
          end
        end
      end
    end
  end

  describe "game#round_counter" do
    it "doesn't create invalid defaults" do
      expect(game).to be_valid
    end

    it "defaults to 0" do
      expect(game.round_counter).to be 0
    end

    it "guards against negative numbers" do
      game.round_counter = -1
      expect(game).to_not be_valid
    end

    it "allows positive integers" do
      game.round_counter = 1
      expect(game).to be_valid
    end

    it "allows large positive integers" do
      game.round_counter = 9876
      expect(game).to be_valid
    end
  end
end
