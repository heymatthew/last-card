require 'rails_helper'

RSpec.describe StartGame do
  let(:player1) { Player.new }
  let(:player2) { Player.new }
  let(:game)    { Game.new }
  let(:service) { StartGame.new(game) }

  context "before the game is ready" do
    it "does not allow the game to start" do
      expect(service.call).to be false
    end
  end
end
