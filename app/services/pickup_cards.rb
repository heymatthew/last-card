class PickupCards < Struct.new(:player, :game, :pickups_count)
  def call
    game.with_lock do
      pickups_count.times do
        pickup_card

        break if errors.any?

        shuffle_pile if no_cards_in_deck?
      end

      increment_round!
    end
    errors.none?
  end

  def errors
    @errors ||= []
  end

  private

  def shuffle_pile
    #binding.pry
    player.shuffle!
    rebuild_round
  end

  def pickup_card
    if cards_in_deck?
      card = round.deck.pickup
      player.pickup!(card)
    else
      errors.push "ran out of cards to pick up"
    end
  end

  def increment_round!
    round.game.round_counter += 1
    round.game.save!
  end

  def cards_in_deck?
    round.deck.any?
  end

  def no_cards_in_deck?
    !cards_in_deck?
  end

  def round
    @round ||= Round.new(game)
  end

  def rebuild_round
    @round = Round.new(game)
  end
end
