require 'rails_helper'
require_relative 'shared_examples'

RSpec.describe PickupCard do
  # predictable seed for predictable shuffles
  before { srand 1 }

  let(:user1)   { User.create!(nickname: "megatron") }
  let(:user2)   { User.create!(nickname: "optimus") }
  let(:game)    { Game.create! }
  let(:service) { PickupCard.new(user1, round) }

  def round
    Round.new(game)
  end

  def hand
    round.hands[user1.nickname]
  end

  context "before a game has started" do
    it_behaves_like "a service with errors"
  end

  context "when game is over" # TODO

  context "when there are no cards in the deck" do
    before do
      round.deck.each do |card|
        user2.play!(game, card)
      end
    end

    it_behaves_like "a service with errors"
  end

  context "after the game has started" do
    before do
      game.users << user1
      game.users << user2
      game.save!
      StartGame.new(game).call or fail "untestable"
    end

    it "executes successfully" do
      expect(service.call).to be true
    end

    it "adds cards to the user's hand" do
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
