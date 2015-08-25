class GamesController < ApplicationController
  before_filter :lookup_user

  def index
    @games = Game.where(pending: true)
  end

  def show
    @player = get_player
    @game = Game.find(params[:id])
  end

  def new
    redirect_to Game.create!
  end

  private

  def get_player
    Game.players.find_or_create_by(user: @user)
  end

  def lookup_user
    @user = User.find(session[:user_id])
  rescue ActiveRecord::RecordNotFound
    @user = nil
  end
end
