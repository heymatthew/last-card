class GamesController < ApplicationController
  def index
    @games = Game.where(pending: true)
  end

  # TODO player joins
  def show
    @game = Game.find(params[:id])
  end

  def create
    redirect_to Game.create!
  end
end
