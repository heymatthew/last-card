RSpec.shared_examples "subject has pickup option" do
  it "has pickup option" do
    expect(subject.options.keys).to include Action::PICKUP
  end
end

RSpec.describe GamePlan do
  let(:user1)  { User.create!(nickname: "Mc_Bane") }
  let(:user2)  { User.create!(nickname: "Rainier_Wolfcastle") }
  let(:game)   { Game.create! }
  let(:round)  { Round.new(game) }

  let(:player) { game.current_turn }
  let(:oponent) { game.players.last }

  let(:pickup_two)   { Card.new('2','hearts') }
  let(:pickup_five)  { Card.new('5','hearts') }
  let(:vanilla_card) { Card.new('3','hearts') }

  subject { GamePlan.new(player, round) }

  context "after game starts" do
    before do
      user1.players.create!(game: game)
      user2.players.create!(game: game)
      game.update!(pending: false)
    end

    context "when pile shows pickup 5 on top" do
      before do
        player.pickup!(pickup_two)
        player.play!(pickup_five)
      end

      include_examples "subject has pickup option"

      it "player may need to pickup 5" do
        expect(subject.options[Action::PICKUP]).to be 5
      end

      it "player could respond with pickups in their hand" do
        expect(subject.options[Action::PLAY]).to include pickup_two
      end

      context "after oponent already picked up" do
        before { oponent.pickup!(vanilla_card) }

        it "player doesn't need to pickup those cards" do
          expect(subject.options[Action::PICKUP]).to be 1
        end
      end
    end
  end
end
