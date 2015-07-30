require 'rails_helper'
require_relative 'shared_examples'

RSpec.shared_examples "a playable service" do
  describe "when called" do
    it "succeeds" do
      expect(service.call).to eq true
    end

    it "add card to pile" do
      expect { service.call }.to change { round.pile.last }.to card
    end

    it "removes played card from player's hand" do
      expect(hand.map(&:to_s)).to include(card.to_s)
      service.call
      expect(hand.map(&:to_s)).to_not include(card.to_s)
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
  let(:bad_suits) { CardDeck::SUITS - [top_card.suit] }
  let(:bad_ranks) { CardDeck::RANKS - [top_card.rank] }
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

    context "a card that doesn't share rank or suit with pile top" do
      let(:card) { bad_card }
      it_behaves_like "a service with errors"
    end

    let(:top_suit) { round.pile.last.suit }
    let(:top_rank) { round.pile.last.rank }

    let(:is_top_suit) { ->(card) { card.suit == top_suit } }
    let(:is_top_rank) { ->(card) { card.rank == top_rank } }

    context "a card of same rank as pile top" do
      # make sure the player has a known good card
      # wrong suit, but right rank
      let(:card) { round.deck.reject(&is_top_suit).find(&is_top_rank) }

      # pick up a card of the right type from the deck
      before { player1.pickup!(card) }

      it_behaves_like "a playable service"
    end

    context "a card of same suit as pile top" do
      # make sure hte player has a known good card
      # wrong rank, right suit
      let(:card) { round.deck.reject(&is_top_suit).find(&is_top_rank) }

      # pick up a card of the right type from the deck
      before { player1.pickup!(card) }

      it_behaves_like "a playable service"
    end
  end

  context "when game is over" # TODO
end
