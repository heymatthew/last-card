class PlayCard
  attr_reader :errors

  def initialize(player, round, card)
    @player = player
    @round  = round
    @card   = card
    @errors = []
  end

  def call
    @round.game.with_lock do
      check_legal_move

      play_card! && increment_round! if errors.none?
    end

    errors.none?
  end

  private

  # TODO push out to player_options class and use a validate method
  def check_legal_move
    top_card = @round.pile.top
    if !@card.playable_on?(top_card)
      errors.push "cannot play card, #{@card} on #{top_card}"
    end
  end

  def play_card!
    @player.play!(@card)
  end

  def increment_round!
    @round.game.round_counter += 1
    @round.game.save!
  end
end
