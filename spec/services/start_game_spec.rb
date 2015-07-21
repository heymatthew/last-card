require 'rails_helper'

RSpec.shared_examples "a service with errors" do
  context "when called" do
    it "bails" do
      expect(service.call).to be false
    end

    it "gives errors" do
      expect { service.call }.to change { service.errors.size }.by(1)
    end
  end
end

RSpec.describe StartGame do
  let(:player1) { Player.create!(nick: "batman")   }
  let(:player2) { Player.create!(nick: "tothemax") }
  let(:game)    { Game.create! }
  let(:service) { StartGame.new(game) }

  context "when called" do
    context "before players have joined" do
      it_behaves_like "a service with errors"
    end

    context "and game not #ready?" do
      before { game.players << player1 }
      it_behaves_like "a service with errors"
    end

    context "more than once" do
      before do
        game.players << player1
        game.players << player2
        second_service = StartGame.new(game)
        expect(second_service.call).to be true
      end

      it_behaves_like "a service with errors"
    end

    context "and game is #ready?" do
      before do
        game.players << player1
        game.players << player2
      end

      it "runs" do
        expect(service.call).to be true
      end

      it "has no errors" do
        expect { service.call }
          .to_not change { service.errors.size }
      end

      it "is no longer #pending" do
        expect { service.call }
          .to change { game.pending }
          .from(true).to(false)
      end

      it "deals cards to players" do
        expect { service.call }
          .to change { Action.all.count }
          .from(0).to(10) # 2 players, 10 cards
      end

      it "does not repeat delt cards to players" do
        srand 1 # predictable seed
        expect { service.call }
          .to change { Action.all.map(&:card).uniq.size }
          .from(0).to(10) # 10 unique cards
      end
    end
  end
end
