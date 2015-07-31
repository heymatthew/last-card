class Deck < Array
  def pickup
    shuffle_offset = rand(length)
    delete_at(shuffle_offset)
  end
end
