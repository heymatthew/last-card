class PlayerOptions < Struct.new(:player, :round)
  def options
    if !round.game.started? || !players_turn?
      not_your_turn 
    elsif top_card.pickup?
      strategy_defence
    else
      strategy_playable_cards
    end
  end

  private

  def players_turn?
    round.game.current_turn == player
  end

  def strategy_defence
    {
      Action::PICKUP => round.pile.pickup_count,
      Action::PLAY => hand.pickup_defence(top_card),
    }
  end

  def strategy_playable_cards
    {
      Action::PICKUP => 1,
      Action::PLAY => hand.select_playable(top_card),
    }
  end

  def not_your_turn
    {}
  end

  def hand
    round.hands[player.nickname]
  end

  def top_card
    round.pile.top
  end
end
