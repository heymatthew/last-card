class Pile < Array
  def top
    last
  end

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
