class GamePlan < Struct.new(:player, :round)
  def options
    if !round.game.started? || !players_turn?
      not_your_turn 
    elsif need_to_defend
      strategy_defence
    else
      strategy_playable_cards
    end
  end

  private

  def players_turn?
    round.game.current_player == player
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
    round.hands[player.id]
  end

  def top_card
    round.pile.top
  end

  def need_to_defend
    top_card.pickup? && last_action.effect == Action::PLAY
  end

  def last_action
    round.game.actions.last
  end
end
