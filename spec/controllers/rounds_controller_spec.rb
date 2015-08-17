require 'rails_helper'

RSpec.describe RoundsController, type: :controller do
  render_views # needed for response.body tests

  def response_json
    ActiveSupport::JSON.decode @response.body
  end

  describe "GET index" do
    let(:game)     { Game.create! }
    let(:megatron) { User.create(nickname: "megatron") }
    let(:optimus)  { User.create(nickname: "optimus") }

    before do
      game.players.create!(user: megatron)
      game.players.create!(user: optimus)
      service = StartGame.new(game)
      service.call or fail "Untestable: #{service.errors.to_full_sentence}"
      get :index, { game_id: game.id }
    end

    it "has player hands" do
      expect(response_json["hands"].keys).to match_array ["optimus", "megatron"]
    end
  end
end
