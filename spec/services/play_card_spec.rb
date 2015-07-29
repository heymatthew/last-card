require 'rails_helper'
require_relative 'shared_examples'

RSpec.shared_examples "they update game state" do
  describe "when called" do
    it "add card to pile" do
      expect { service.call }.to change { round.pile.last }.to card
    end

    it "removes played card from player's hand" do
      expect(hand).to include(card)
      service.call
      expect(hand).to_not include(card)
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
  let(:top_card)  { round.pile.last }
  let(:bad_suits) { Card::SUITS - [top_card.suit] }
  let(:bad_ranks) { Card::RANKS - [top_card.rank] }
  let(:bad_card)  { Card.find_by(rank: bad_ranks.last, suit: bad_suits) }

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

    context "cards of wrong rank and suit" do
      let(:card) { bad_card }
      it_behaves_like "a service with errors"
    end

    # make sure the player has a known good card
    # pick up a card of the right type from the deck
    before { player1.pickup!(card) }

    context "cards of same rank" do
      # grab a card of the right rank from the deck
      let(:card) do
        top_rank = round.pile.last.rank
        round.deck.find { |card| card.rank == top_rank }
      end

      it_behaves_like "they update game state"
    end

    context "cards of same suit" do
      # grab a card of the right rank from the deck
      let(:card) do
        top_suit = round.pile.last.suit
        round.deck.find { |card| card.suit == top_suit }
      end

      it_behaves_like "they update game state"
    end

  end

  context "when game is over" # TODO
end
