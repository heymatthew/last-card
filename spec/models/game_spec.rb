require 'rails_helper'

RSpec.describe Game, type: :model do
  let(:game) { Game.create! }
  let(:player1) { Player.create! }
  let(:player2) { Player.create! }

  context("when fewer than 2 players") do
    before do
      game.players << player1
      game.save
    end

    it "is not #ready? to start" do
      expect(game).to_not be_ready
    end
  end

  context("with 2 players") do
    before do
      game.players << player1
      game.players << player2
      game.save
    end

    it "to be #ready?" do
      expect(game).to be_ready
    end
  end
end
