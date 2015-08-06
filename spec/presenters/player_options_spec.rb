RSpec.shared_examples "subject has pickup option" do
  it "has pickup option" do
    expect(subject.options.keys).to include Action::PICKUP
  end
end

RSpec.describe PlayerOptions do
  let(:user1)  { User.create!(nickname: "Mc_Bane") }
  let(:user2)  { User.create!(nickname: "Rainier_Wolfcastle") }
  let(:game)   { Game.create! }
  let(:round)  { Round.new(game) }

  let(:player) { game.current_turn }

  let(:two_of_hearts)  { Card.new('2','hearts') }
  let(:five_of_hearts) { Card.new('5','hearts') }

  subject { PlayerOptions.new(player, round) }

  context "before game has started" do
    it "returns no options" do
      expect(subject.options).to be {}
    end
  end

  context "after game starts" do
    before do
      user1.players.create!(game: game)
      user2.players.create!(game: game)
      game.update!(pending: false)
    end

    context "when pile has pickup as top card" do
      before do
        player.pickup!(two_of_hearts)
        player.play!(five_of_hearts)
      end

      include_examples "subject has pickup option"

      it "is reflected in the pickup option" do
        expect(subject.options[Action::PICKUP]).to be > 1
      end

      it "allows the player to respond with a pickup" do
        expect(subject.options[Action::PLAY]).to include two_of_hearts
      end
    end
  end
end
