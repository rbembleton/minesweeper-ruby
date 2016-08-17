require_relative "tile.rb"
require_relative "board.rb"

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
    @pos = get_position
    change = do_what
    change == :f ? @board.flag(@pos) : @board.uncover(@pos)
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
    temp_arr_no_bombs = temp_arr.reject { |el| el.check_if_bomb }
    if temp_arr_no_bombs.any? { |el| !el.check_revealed }
      return false
    elsif temp_arr_no_bombs.all? { |el| el.check_revealed }
      @board.uncover_all(:W)
      @won = @board[@pos].check_if_bomb ? false : true
      return true
    end
    temp_arr.all?  { |el| el.check_revealed }
  end

end

if __FILE__ == $PROGRAM_NAME
  system('clear')
  puts "Welcome to Minesweeper! What size board do you want? Big, medium, or small? (b, m, s)"
  size = gets.chomp.downcase

  case size
  when 'b'
    board_size = 20
  when 'm'
    board_size = 15
  else
    board_size = 11
  end

  puts "Cool! On a scale of 1-10 how hard do you want the game to be? (1-10, 10 is the hardest)"
  hard = gets.chomp.to_i

  while hard < 1 || hard > 10
    puts "Hmm... that's not right! Try again (1-10)"
    hard = gets.chomp.to_i
  end


  new_game = MinesweeperGame.new(Board.new(board_size, (hard / 2.7) + 0.5))
  new_game.play

end
