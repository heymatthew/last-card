require 'rails_helper'
require_relative 'shared_examples'

RSpec.shared_examples "a playable service" do
  describe "when called" do
    it "succeeds" do
      expect(service.call).to eq true
    end

    it "add card to pile" do
      expect { service.call }.to change { round.pile.top }.to card
    end

    it "removes played card from player's hand" do
      expect(hand.map(&:to_s)).to include(card.to_s)
      service.call
      expect(hand.map(&:to_s)).to_not include(card.to_s)
    end

    it "increments the round" do
      expect { service.call }.to change { game.round_counter }.by(1)
    end
  end
end

RSpec.describe PlayCard do
  let(:game)     { Game.create! }
  let(:optimus)  { User.create!(nickname: "optimus") }
  let(:megatron) { User.create!(nickname: "megatron") }
  let(:player1)  { optimus.players.build }
  let(:player2)  { megatron.players.build }

  def round
    Round.new(game)
  end

  def hand
    round.hands[player1.nickname]
  end

  let(:good_card) { hand.first }
  let(:top_card)  { round.pile.top }
  let(:bad_suits) { Card::SUITS - [top_card.suit] }
  let(:bad_ranks) { Card::RANKS - [top_card.rank] - ['ace'] }
  let(:bad_card)  { Card.new(bad_ranks.last, bad_suits.last) }

  let(:card)    { Card.first }
  let(:service) { PlayCard.new(player1, round, card) }

  context "when game is over" # TODO

  context "after the game has started" do
    before do
      game.players << player1
      game.players << player2
      game.save!
      StartGame.new(game).call or fail "untestable"
    end

    context "a card that is not #playable_on? top card" do
      let(:card) { bad_card }
      it_behaves_like "a service with errors"
    end

    let(:top_suit) { round.pile.top.suit }
    let(:card) { Card.new("5", top_suit) }

    context "a card that is #playable_on? the top card" do
      # make sure player has it in their hand
      before { player1.pickup!(card) }
      it_behaves_like "a playable service"
    end
  end

  context "when game is over" # TODO
end
