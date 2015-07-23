require 'rails_helper'

RSpec.shared_examples "full deck in play" do
  context "the game" do
    let(:full_deck) { Card.deck }
    it "has 52 cards total"
    it "does not repeat cards in game"
  end
end

RSpec.describe Table do
  # predictable seed for predictable shuffles
  before { srand 1 }

  let(:player) { game.players.first }
  let(:game) { Game.create! }

  before do
    game.players.create!(nick: "tintin")
    game.players.create!(nick: "snowy")
  end

  def table
    Table.new(game)
  end

  def hand
    table.hands[player.nick]
  end

  context "before game start" do
    it "has a full deck of cards" do
      expect(table.deck.size).to be 52
    end

    it "has no allocation to hands" do
      expect(table.hands).to be_empty
    end

    it "has no discard" do
      expect(table.pile).to be_empty
    end
  end

  context "in play" do
    before { StartGame.new(game).call or fail "untestable" }

    context "when game starts" do
      it "gives each player 5 cards" do
        table.hands.values.each do |hand|
          expect(hand.size).to be 5
        end
      end

      it "puts a card on the pile" do
        expect(table.pile.size).to be 1
      end
    end

    context "when player picks up" do
      let(:card) { table.deck.first }

      subject { player.pickup!(game,card) }

      it "does not change pile" do
        expect { subject }.to_not change { table.pile.size }
      end

      it "removes cards from the deck" do
        expect { subject }.to change { table.deck.size }.by(-1)
      end

      it "adds cards to player's hand" do
        expect { subject }.to change { table.hands.values.flatten.size }.by(1)
      end

      context "after action" do
        before { player.pickup!(game,card) }

        it "removed picked up card from deck" do
          expect(table.deck).to_not include card
        end

        it "added the pickup to players hand" do
          expect(hand).to include card
        end
      end
    end

    context "when card is played" do
      # card now comes from a players hand
      let(:card) { hand.first }

      subject { player.play!(game ,card) }

      it "removes cards from player's hand" do
        expect { subject }.to change { table.hands[player.nick].size }.by(-1)
      end

      it "only removes from one of the players hands" do
        expect { subject }.to change { table.hands.values.flatten.size }.by(-1)
      end

      # rename table to round !! fool
      # PlayCard.new(table, Oplayer, card).call
      it "adds cards to the pile" do
        expect { subject }.to change { table.pile.size }.by(+1)
      end

      it "does not change the deck" do
        expect { subject }.to_not change { table.deck.size }
      end

      context "after action" do
        before { player.play!(game,card) }

        it "removed card from players hand" do
          expect(hand).to_not include card
        end

        it "contains the card in the pile" do
          expect(table.pile).to include card
        end

        it "put the card on the top of the pile" do
          expect(table.pile.last).to eq card
        end
      end
    end
  end
end
