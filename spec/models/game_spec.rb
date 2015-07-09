require 'rails_helper'

RSpec.describe Game, type: :model do
  let(:game) { Game.new }
  let(:player1) { Player.new }
  let(:player2) { Player.new }

  context("when fewer than 2 players") do
    before { game.players << player1 }

    it "is not #ready? to start" do
      expect(game).to_not be_ready
    end
  end

  context("with 2 players") do
    before do
      game.players << player1
      game.players << player2
    end

    it "is #ready? to start" do
      expect(game).to be_ready
    end
  end
end
