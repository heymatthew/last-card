class StartGame
  attr_reader :errors

  def initialize(game)
    @game = game
    @errors = []
  end

  def call
    @errors.push "game not ready to start" unless @game.ready?
    @errors.none?
  end
end
