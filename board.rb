class Board

  def initialize

  

  end

  def make_bomb_grid(size=9)
    bomb_array = Array.new(size**2 - size * 1.5)
    bomb_array += Array.new(size * 1.5, :B)

    bomb_array.shuffle!

    (1..size).map { bomb_array.pop(size) }
  end




end
