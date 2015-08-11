class Pile < Array
  DEFAULT_PICKUP = 0

  def top
    last
  end

  # FIXME bug, when shuffle happens we lose count
  # This logic should live in GamePlan
  # game.plays.reverse ...
  def pickup_count
    reverse
      .take_while(&:pickup?)
      .map(&:pickup_count)
      .inject(DEFAULT_PICKUP, :+)
  end

  def pickup?
    top.pickup?
  end
end
