require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  render_views # needed for response.body tests

  describe "GET new" do
    before do
      User.create!(email: "megatron@decepticons.com")
      User.create!(email: "optimus@autobots.com")
    end

    it "creates a game after called" do
      expect { get :new }.to change { Game.all.count }.by 1
    end

    it "redirects to game after called" do
      get :new
      expect(response).to redirect_to(Game.first)
    end
  end

  describe "GET show" do
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
      let(:megatron) { User.create!(email: "megatron@decepticons.com") }
      let(:optimus)  { User.create!(email: "optimus@autobots.com") }

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

  describe "GET index" do
    let(:game_pending) { Game.create! }
    let(:game_in_play) { Game.create!(pending: false) }

    before do
      game_pending # observe to create
      game_in_play # observe to create
      get :index
    end

    it "shows games that are pending" do
      expect(assigns(:games)).to include game_pending
    end

    it "does not show games that have started" do
      expect(assigns(:games)).to_not include game_in_play
    end

    it "renders the index template" do
      expect(response).to render_template('index')
    end
  end
end
