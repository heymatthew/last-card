require 'rails_helper'

RSpec.describe StartGame do
  let(:player1) { Player.new }
  let(:player2) { Player.new }
  let(:game)    { Game.new }
  let(:service) { StartGame.new(game) }

  context "when called" do
    context "and game not #ready?" do
      before { game.players << player1 }

      it "bails" do
        expect(service.call).to be false
      end

      it "gives errors" do
        expect { service.call }.to change { service.errors.size }.by(1)
      end
    end

    context "and game is #ready?" do
      before do
        game.players << player1
        game.players << player2
      end

      it "runs" do
        expect(service.call).to be true
      end

      it "has no errors" do
        expect { service.call }.to_not change { service.errors.size }
      end
    end
  end
end
