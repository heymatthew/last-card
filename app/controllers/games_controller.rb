class GamesController < ApplicationController
  before_filter :lookup_user

  def index
    @games = Game.where(pending: true)
  end

  def show
    @game = game
    @player = player
  end

  def new
    redirect_to Game.create!
  end

  private

  def player
    @game.players.find_or_create_by(user: @user)
  end

  def game
    Game.find(params[:id])
  end

  def lookup_user
    if session[:user_id]
      @user ||= User.find(session[:user_id])
    end
  end
end
