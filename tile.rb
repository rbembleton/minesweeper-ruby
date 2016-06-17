class Tile

  def initialize(value_or_bomb)

    @is_bomb = value_or_bomb == :B ? true : false
    @revealed = false
    @flagged = false
    @display_value = value_or_bomb
    @player_lost = false

  end

  def value
    @display_value
  end

  def check_revealed
    @revealed
  end

  def check_if_bomb
    @is_bomb
  end

  def reveal
    @revealed = true
  end

  def make_angry_face
    @player_lost = true
  end

  def toggle_flagged
    @flagged = @flagged ? false : true
  end

  def to_s
    return " 🚩 " if @flagged && @revealed == false
    return " ⏹ " unless @revealed
    return " 😡 " if @is_bomb && @player_lost
    return " 😎 " if @is_bomb
    return "   " if @display_value == 0
    " #{@display_value} "
  end



end
