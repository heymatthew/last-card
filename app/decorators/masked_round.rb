class MaskedRound < Struct.new(:round, :player)
  def hand
    @hand ||= round.hands[player.id]
  end

  def oponent_hands
    @masked_oponent_hands ||= masked_oponent_hands
  end

  def deck
    round.deck.size
  end

  def pile
    round.pile
  end

  private

  def masked_oponent_hands
    oponent_hands.each.with_object({}) do |(oponent,hand), masked_hands|
      masked_hands[oponent] = hand.size
    end
  end

  def oponent_hands
    round.hands.slice(*oponents)
  end

  def oponents
    round.hands.keys - [player.id]
  end
end
