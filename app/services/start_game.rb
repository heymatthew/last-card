class StartGame
  attr_reader :errors

  def initialize(game)
    @game = game
    @errors = []
  end

  def call
    assert_game_ready && remove_pending

    @errors.none?
  end

  private

  def assert_game_ready
    @game.ready?.tap do |ready|
      @errors.push "game not ready to start" if !ready
    end
  end

  def remove_pending
    @game.pending.tap do |pending|
      if pending
        @game.pending = false
      else
        @errors.push "game already started"
      end
    end
  end
end
