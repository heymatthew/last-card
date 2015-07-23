require 'rails_helper'
require_relative 'shared_examples'

RSpec.describe PickupCard do
  # predictable seed for predictable shuffles
  before { srand 1 }

  let(:player1) { Player.create!(nickname: "megatron") }
  let(:player2) { Player.create!(nickname: "optimus") }
  let(:game)    { Game.create! }
  let(:service) { PickupCard.new(player1, round) }

  def round
    Round.new(game)
  end

  def hand
    round.hands[player1.nickname]
  end

  context "before a game has started" do
    it_behaves_like "a service with errors"
  end

  context "when game is over" # TODO

  context "when there are no cards in the deck" do
    before do
      round.deck.each do |card|
        player2.play!(game, card)
      end
    end

    it_behaves_like "a service with errors"
  end

  context "after the game has started" do
    before do
      game.players << player1
      game.players << player2
      game.save!
      StartGame.new(game).call or fail "untestable"
    end

    it "executes successfully" do
      expect(service.call).to be true
    end

    it "adds cards to the players hand" do
      expect { service.call }.to change { hand.size }.by(1)
    end

    it "removes cards from the deck" do
      expect { service.call }.to change { round.deck.size }.by(-1)
    end

    it "does not change the pile" do
      expect { service.call }.to_not change { round.pile }
    end
  end
end