require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  render_views # needed for response.body tests

  context "GET new" do
    it "creates a game after called" do
      expect { get :new }.to change { Game.all.count }.by 1
    end

    it "redirects to game after called" do
      get :new
      expect(response).to redirect_to(Game.first)
    end
  end

  context "GET show" do
    def request_for(game_id)
      get :show, id: game_id
    end

    it "explodes with negative game id" do
      expect { request_for(-1) }.to raise_error ActiveRecord::RecordNotFound
    end

    it "explodes with alpha game id" do
      expect { request_for("fu") }.to raise_error ActiveRecord::RecordNotFound
    end

    it "explodes with non existant game id" do
      expect { request_for(666) }.to raise_error ActiveRecord::RecordNotFound
    end

    context "a game in progress" do
      let(:game)     { Game.create! }
      let(:megatron) { User.create(nickname: "megatron") }
      let(:optimus)  { User.create(nickname: "optimus") }

      before do
        game.players.create!(user: megatron)
        game.players.create!(user: optimus)
      end

      it "can find a game in progress" do
        request_for(game.id)
        expect(response).to render_template('show')
      end
    end
  end
end
