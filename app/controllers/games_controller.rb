class GamesController < ApplicationController
  before_filter :lookup_user

  def index
    @games = Game.where(pending: true)
  end

  # TODO player joins
  def show
    @game = Game.find(params[:id])
    @player = @game.current_turn

    @round = Round.new(@game)
    @options = GamePlan.new(@player, @round)
    @player = @user.players.where(game: @game).first # TODO change this plz
  end

  def new
    game = Game.create!
    game.players.create!(user: User.first)
    game.players.create!(user: User.last)
    StartGame.new(game).call or fail "Mega fail"
    redirect_to game
  end

  private

  def lookup_user
    @user = User.first # TODO actually have a real user!
  end
end
