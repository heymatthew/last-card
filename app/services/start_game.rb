class StartGame
  attr_reader :errors

  def initialize(game)
    @game = game
    @errors = []
  end

  def call
    @errors.any?
  end
end
