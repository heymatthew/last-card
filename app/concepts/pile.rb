class Pile < Array
  def top
    last
  end

  def pickup_count
    0 if top.pickup.nil?

    pickup_count = 0
    cards = self.clone
    while card = cards.pop
      break if card.pickup.nil?
      pickup_count += card.pickup
    end

    pickup_count
  end
end
