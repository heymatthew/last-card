class Pile < Array
  def top
    last
  end

  # FIXME bug, when shuffle happens we lose count
  # This logic should live in GamePlan
  # game.plays
  #     .reverse
  #     .take_while(&:pickup?)
  #     .map(&:pickup_count)
  #     .inject(:+)
  def pickup_count
    if pickup?
      reverse
        .take_while(&:pickup?)
        .map(&:pickup_count)
        .inject(:+)
    else
      0
    end
  end

  def pickup?
    top.pickup?
  end
end
