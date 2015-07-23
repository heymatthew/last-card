class Table
  attr_reader :hands
  attr_reader :deck
  attr_reader :pile

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
      @game.players.each do |player|
        pickups = player.pickups.map(&:card)
        plays   = player.plays.map(&:card)
        @hands[player.nick] = pickups - plays
      end
    end
  end

  def calculate_pile
    @pile = []

    if @game.started?
      @pile = @game.actions.play.map(&:card)
    end
  end

  def calculate_deck
    cards_in_play = @pile + @hands.values.flatten
    @deck = Card.deck - cards_in_play
  end
end
