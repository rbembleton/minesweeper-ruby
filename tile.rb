class Tile

  def initialize(is_bomb)

    @is_bomb = is_bomb==:B ? true : false
    @revealed = false
    @flagged = false
    @display_value = is_bomb

  end





end
