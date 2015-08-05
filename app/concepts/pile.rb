class Pile < Array
  def top
    last
  end

  def pickup_count
    total_pickups = 0

    # TODO tidy this up
    cards = self.clone
    while card = cards.pop
      break unless card.pickup?
      total_pickups += card.pickup_count
    end

    total_pickups
  end

  def pickup?
    top.pickup?
  end
end
