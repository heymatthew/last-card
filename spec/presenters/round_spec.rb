require 'rails_helper'

RSpec.describe Round do
  # predictable seed for predictable shuffles
  before { srand 1 }

  let(:player) { game.players.first }
  let(:game)   { Game.create! }

  before do
    game.users.create!(nickname: "tintin")
    game.users.create!(nickname: "snowy")
  end

  def round
    Round.new(game)
  end

  def hand
    round.hands[player.nickname]
  end

  context "before game start" do
    it "has a full deck of cards" do
      expect(round.deck.size).to be 52
    end

    it "has no allocation to hands" do
      expect(round.hands).to be_nil
    end

    it "has no discard" do
      expect(round.pile).to be_nil
    end
  end

  context "in play" do
    before { StartGame.new(game).call or fail "untestable" }

    context "when game starts" do
      it "gives each player 5 cards" do
        round.hands.values.each do |hand|
          expect(hand.size).to be 5
        end
      end

      it "puts a card on the pile" do
        expect(round.pile.size).to be 1
      end
    end

    context "when player picks up" do
      let(:card) { round.deck.first }

      subject { player.pickup!(card) }

      it "does not change pile" do
        expect { subject }.to_not change { round.pile.size }
      end

      it "removes cards from the deck" do
        expect { subject }.to change { round.deck.size }.by(-1)
      end

      it "adds cards to player's hand" do
        expect { subject }.to change { round.hands.values.flatten.size }.by(1)
      end

      context "after action" do
        before { player.pickup!(card) }

        it "removed picked up card from deck" do
          expect(round.deck).to_not include card
        end

        it "added the pickup to player's hand" do
          expect(hand).to include card
        end
      end
    end

    context "when card is played" do
      # card now comes from a player's hand
      let(:card) { hand.first }

      subject { player.play!(card) }

      it "removes cards from player's hand" do
        expect { subject }.to change { round.hands[player.nickname].size }.by(-1)
      end

      it "only removes from one of the player's hands" do
        expect { subject }.to change { round.hands.values.flatten.size }.by(-1)
      end

      it "adds cards to the pile" do
        expect { subject }.to change { round.pile.size }.by(+1)
      end

      it "does not change the deck" do
        expect { subject }.to_not change { round.deck.size }
      end

      context "after action" do
        before { player.play!(card) }

        it "removed card from player's hand" do
          expect(hand).to_not include card
        end

        it "contains the card in the pile" do
          expect(round.pile).to include card
        end

        it "put the card on the top of the pile" do
          expect(round.pile.top).to eq card
        end
      end
    end

    context "when deck is ready for reshuffle" do
      let(:top_card)    { hand.first }
      let(:last_round)  { round }

      before do
        # player plays a card
        player.play!(top_card)

        # player picks up all cards
        last_round.deck.each do |card|
          player.pickup!(card)
        end
      end

      describe "the pile" do
        it "gets emptied of all but 1 card" do
          expect(round.pile.size).to be 1
        end

        # TODO options concept
        # TODO concepts for rules
        # TODO concept for shuffle rule
        #  - When am I going to shuffle
        #  - Abstract this from the round service
        #  - Make the round service take advantage of this shuffle rule
        #  - Move these integration tests to work against the rule rather than the round
        #
        # Because the shuffle rules are mission critical to the game
        # we should be using unit tests on them to be more sure of their correctness
        # Integration tests cannot cover edge cases of the application :)
        it "keeps the last card played on the top" do
          expect(round.pile.top).to eq last_round.pile.top
        end
      end

      describe "the deck" do
        it "shuffles in cards from the pile" do
          expect(round.deck.size).to be 1
        end

        it "contains the first card played by the dealer" do
          expect(round.deck).to include last_round.pile.first
        end
      end

      context "the next play" do
        let(:next_played_card) { hand.last }

        before { player.play!(next_played_card) }

        describe "the pile" do
          it "has 2 cards" do
            expect(round.pile.size).to be 2
          end

          it "still has the last play from before shuffle" do
            expect(round.pile.first).to eq last_round.pile.top
          end

          it "now shows the played card on top of the pile" do
            expect(round.pile.top).to eq next_played_card
          end
        end

        describe "the deck" do
          it "still only has cards from previous pile" do
            expect(round.deck.size).to be 1
          end

          it "contains the first card played by the dealer" do
            expect(round.deck).to include last_round.pile.first
          end

          it "does not contain the card just played" do
            expect(round.deck).to_not include next_played_card
          end
        end
      end
    end
  end

  context "when the game ends" # TODO
end
