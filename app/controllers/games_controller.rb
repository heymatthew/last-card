class GamesController < ApplicationController
  before_filter :lookup_user

  def index
    @games = Game.where(pending: true)
  end

  # TODO player joins
  def show
    @game = Game.find(params[:id])
    @round = Round.new(@game)
    @player = @user.players.where(game: @game).first # TODO change this plz
  end

  def new
    redirect_to Game.create!
  end

  private

  def lookup_user
    @user = User.first # TODO actually have a real user!
  end
end
