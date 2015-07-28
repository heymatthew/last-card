class Round
  attr_reader :game

  attr_reader :hands
  attr_reader :deck
  attr_reader :pile

  # TODO make hands/deck/pile lazy
  def initialize(game)
    @game = game

    calculate_hands
    calculate_pile
    calculate_deck
  end

  private

  def calculate_hands
    @hands = {}

    if @game.started?
      @game.users.each do |user|
        pickups = user.pickups.map(&:card)
        plays   = user.plays.map(&:card)
        @hands[user.nickname] = pickups - plays
      end
    end
  end

  def calculate_pile
    @pile = []

    if @game.started?
      shuffles = @game.pickups.count / Card.deck.size

      if shuffles.zero?
        # pile = played cards
        @pile = @game.plays.map(&:card)
      else
        # based on the last card that triggered the shuffle
        shuffle_trigger = @game.pickups[ Card.deck.size * shuffles - 1 ]
        shuffle_time = shuffle_trigger.created_at

        # pile = previous top card + played cards since
        @pile = [previous_pile_top(shuffle_time)].concat played_since_shuffle(shuffle_time)
      end
    end
  end

  def previous_pile_top(shuffle_time)
    # TODO use ids instead of times
    @game.plays.where("created_at < ?", shuffle_time).last.card
  end

  def played_since_shuffle(shuffle_time)
    @game.plays.where("created_at > ?", shuffle_time).map(&:card)
  end

  def calculate_deck
    @deck = Card.deck - cards_in_play
  end

  def cards_in_play
    @pile + @hands.values.flatten
  end
end
