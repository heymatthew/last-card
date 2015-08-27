require 'rails_helper'
require 'set'
require_relative 'shared_examples'

RSpec.describe PickupCards do
  # predictable seed for predictable shuffles
  before { srand 1 }

  let(:game)     { Game.create! }
  let(:optimus)  { User.create!(email: "optimus") }
  let(:megatron) { User.create!(email: "megatron") }
  let(:player1)  { optimus.players.create!(game: game) }
  let(:player2)  { megatron.players.create!(game: game) }

  let(:card_count) { 1 }
  let(:service)    { PickupCards.new(player1, game, card_count) }

  def round
    Round.new(game)
  end

  def hand
    round.hands[player1.id]
  end

  context "when game is over" # TODO

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

    it "adds cards to the player's hand" do
      expect { service.call }.to change { hand.size }.by(1)
    end

    it "removes cards from the deck" do
      expect { service.call }.to change { round.deck.size }.by(-1)
    end

    it "does not change the pile" do
      expect { service.call }.to_not change { round.pile }
    end

    context "when there are no cards in the deck" do
      before do
        round.deck.each do |card|
          player2.pickup!(card)
        end
      end

      it_behaves_like "a service with errors"
    end

    context "pickup 5" do
      let(:card_count) { 5 }
      subject { service.call }

      context "when deck has 2 cards" do
        before do
          # Get rid of all but 2 cards in deck
          round.deck.each do |card|
            break if round.deck.size == 2
            player2.pickup!(card)
          end
        end

        context "and pile has at least 5 cards" do
          before do
            # Get player to play 5 cards
            5.times { player2.play!(hand.pop) }
          end

          it "peforms 5 pickup actions" do
            expect { subject }
              .to change { game.pickups.count }
              .by 5
          end

          it "peforms 1 shuffle action" do
            expect { subject }
              .to change {
                binding.pry
                game.shuffles.count
              }
              .by 1
          end

          it "picks up 2 cards from the original deck" do
            deck_before_shuffle = Set.new(round.deck)
            expect { subject }.to change { Set.new(hand).intersect?(deck_before_shuffle) }.to(true)
          end

          it "shuffles the deck" do
            expect { subject }.to change { game.shuffles.count }.by 1
          end

          it "gets 3 more cards from what was the pile" do
            pile_before_shuffle = Set.new(round.pile)
            expect { subject }.to change { Set.new(round.deck).intersect?(pile_before_shuffle) }.to(true)
          end

          it "picks up 5 cards" do
            #expect { subject }.to change { hand.size }.by 5
            expect { subject }.to change {
              #binding.pry
              hand.size
            }.by 5
          end
        end

        context "with a pile of 2 cards" do
          it "picks up 2 from deck, 1 from shuffled pile" do
          end
        end

        context "with pile of 1 card" do
          it "only picks up 2 cards"
        end
      end
    end
  end
end
