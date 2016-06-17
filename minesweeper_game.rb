require_relative "tile.rb"
require_relative "board.rb"

# require "byebug"

class MinesweeperGame
  attr_reader :board

  def initialize(board = Board.new(9,1))
    @board = board
    @won = false
  end


  def play
    play_turn until game_over?
    system("clear")
    @board.render
    puts @won ? "You won!" : "You lost, better luck next time..."
  end

  def play_turn
    system("clear")
    @board.render
    pos = get_position
    change = do_what
    change == :f ? @board.flag(pos) : @board.uncover(pos)
  end

  def get_position
    puts "What position would you like? In the form y,x please!"
    gets.chomp.split(",").map(&:to_i)
  end

  def do_what
    puts "Would you like to toggle flag 'f' or uncover 'u' the tile?"
    gets.chomp.to_sym
  end


  def game_over?
    temp_arr = @board.grid.flatten
    temp_arr_no_bombs = temp_arr.reject {|el| el.check_if_bomb}
    if temp_arr_no_bombs.any? {|el| !el.check_revealed}
      return false
    elsif temp_arr_no_bombs.all? {|el| el.check_revealed}
      @board.uncover_all(:W)
      @won = true
      return true
    end
    temp_arr.all?  {|el| el.check_revealed}
  end

end

if __FILE__ == $PROGRAM_NAME
  # debugger
  new_game = MinesweeperGame.new(Board.new(20,0.5))
  new_game.play

end
