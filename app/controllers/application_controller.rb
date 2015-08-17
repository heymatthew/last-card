class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected

  def setup_game
    @game = Game.find(params[:game_id])
  end

  def setup_round
    @round = Round.new(@game)
  end

  def render_success
    msg = { success: true }
    render(json: msg)
  end

  def render_errors(errors)
    msg = { success: false, errors: errors }
    render(json: msg)
  end
end
