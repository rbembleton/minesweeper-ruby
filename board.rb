class Board
  attr_reader :size, :grid


  def initialize(size = 9, bomb_mod = 1)
    @size = size
    @grid = tileize_bomb_grid(make_bomb_grid(bomb_mod))
  end

  def tileize_bomb_grid(bomb_grid)
    calc_nearby_bombs(bomb_grid).map do |row|
      row.map { |value| Tile.new(value) }
    end
  end

  def make_bomb_grid(bomb_mod = 1)
    bomb_array = Array.new(size ** 2 - size * bomb_mod) ## leaving off one
    bomb_array += Array.new(size * bomb_mod + 1, :B)

    bomb_array.shuffle!

    (1..size).map { bomb_array.pop(size) }
  end

  def calc_nearby_bombs(bomb_grid)
    bomb_grid.map.with_index do |row, idx_r|
      row.map.with_index do |square, idx_c|
        if square == :B
          :B
        else
          find_squares([idx_r,idx_c]).count do |pos|
            bomb_grid[pos[0]][pos[1]] == :B
          end
        end
      end
    end
  end

  def render
    if @size > 10
      output_grid_str = "   #{(0..9).to_a.join("  ")}"
      output_grid_str += "  #{(10..@size-1).to_a.join(" ")} \n"
    else
      output_grid_str += "#{(0..@size-1).to_a.join(" ")} \n"
    end

    @grid.each_with_index do |row, idx|
      output_grid_str += " " if idx<10
      output_grid_str += "#{idx}"
      row.each {|el| output_grid_str += el.to_s}
      output_grid_str += "\n"
    end
    puts output_grid_str

  end

  def [](pos)
    y,x = pos
    @grid[y][x]
  end

  def flag(pos)
    y,x = pos
    @grid[y][x].toggle_flagged
  end

  def uncover(pos)
    y,x = pos
    if @grid[y][x].check_if_bomb == true
      uncover_all(:L)
    else
      uncover_action(pos)
    end

  end

  def uncover_all(win_or_lose)
    @grid.each do |row|
      row.each do |el|
        el.toggle_flagged
        el.make_angry_face if win_or_lose == :L
        el.reveal
      end
    end
  end

  def uncover_action(pos, dont_check = [])
    y,x = pos

    # these two return false to let know that there aren't MORE
    # positions to overturn
    return false if @grid[y][x].check_revealed
    if @grid[y][x].value >= 1 && @grid[y][x].value <=9
      # p "reveal #{y},#{x}"
      @grid[y][x].reveal
      return false
    end

    if @grid[y][x].value == 0
      @grid[y][x].reveal
      temp_arr = find_squares(pos)
      temp_arr.map! {|el| el unless dont_check.include?(el)}
      temp_arr.delete(nil)
      # p temp_arr
      # hi = gets
      temp_arr.each do |new_pos|
          uncover_action(new_pos, dont_check << pos)
      end
    end

    return true

  end

  def find_squares(pos)
    row, col = pos
    row_range = find_squares_adjust_edge(row)
    col_range = find_squares_adjust_edge(col)

    poss_pos = []

    row_range.each do |r|
      col_range.each do |c|
        next if r == 0 && c == 0
        poss_pos << [row + r, col + c]
      end
    end

    poss_pos

  end

  def find_squares_adjust_edge(row_or_col)
    new_array = (-1..1).to_a
    new_array.shift if row_or_col == 0
    new_array.pop if row_or_col == @size - 1
    new_array
  end


end
