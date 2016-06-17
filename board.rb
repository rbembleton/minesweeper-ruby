class Board
  attr_reader :size

  def initialize(size=9)
    @size = size
    @grid = tileize_bomb_grid(make_bomb_grid)
  end

  def tileize_bomb_grid(bomb_grid)
    bomb_grid.map do |row|
      row.map { |value| Tile.new(value) }
    end
  end

  def make_bomb_grid
    bomb_array = Array.new(size ** 2 - size * 1.5)
    bomb_array += Array.new(size * 1.5, :B)

    bomb_array.shuffle!

    (1..size).map { bomb_array.pop(size) }
  end

  def calc_nearby_bombs(bomb_grid)
    bomb_grid.map.with_index do |row, idx_r|
      row.map.with_index do |square, idx_c|
        next if square == :B
        find_squares(idx_r,idx_c).count do |pos|
          bomb_grid[pos[0]][pos[1]] == :B
        end
      end
    end
  end

  def find_squares(pos)
    row, col = pos
    poss_pos = []

    row_range = (-1..1).to_a
    col_range = (-1..1).to_a

    row_range.shift if row == 0
    row_range.pop if row == @size - 1
    col_range.shift if col == 0
    col_range.pop if col == @size - 1

    row_range.each do |r|
      col_range.each do |c|
        next if r == 0 && c == 0
        poss_pos << [row + r, col + c]
      end
    end

    poss_pos
  end
end
