
class Board
  attr_reader :grid

  # standardized matrix creation
  def self.set_board(width, height)
    Array.new(height){Array.new(width)}
  end

  # starts a new board
  def initialize
    @grid = Board.set_board(10, 24)
    @tall_bounds = (0...10)
    @wide_bounds = (0...24)
  end

  # clears completed rows
  # side-effect: returns number of rows cleared
  def clear_filled_rows
    to_clear = []
    @grid.each_with_index { |row, idx| to_clear << idx if row.all? }
    to_clear.each do |idx|
      clear_row(idx)
      add_row
    end
    to_clear.length
  end

  # moves_selected piece to a new position
  def move_piece(piece, position)
    debugger if piece.is_a? Array
    remove_piece(piece)
    place_piece(piece, position)
  end

  # checks for a valid position
  def in_bounds?(coords)
    @wide_bounds.cover?(coords.first) && @tall_bounds.cover?(coords.last)
  end

  # deletes the piece form the board
  def remove_piece(piece)
    @grid.map! do |row|
      row.map! do |cell|
        cell == piece ? nil : cell
      end
    end
  end

  # displays the playable board
  def render
    @grid.each_with_index do |row, idx|
      puts format_row(row, idx)
    end
    puts "######################"
    nil
  end

  def format_row(row, idx)
    row = "#" + row.map { |el| el ? el.to_s : "  " }.join + "#"
    idx < 4 ? row.colorize(background: :light_white) : row
  end

  # helper method to target positions
  def [](position)
    row,col = position
    @grid[row][col]
  end

  # helper method to alter position values
  def []=(position, mark)
    row,col = position
    @grid[row][col] = mark
  end

  private

  # adds a blank row into the grid
  def add_row
    @grid.unshift Array.new(@grid.first.length)
  end

  # deletes a specific row
  def clear_row(num)
    @grid.delete_at(num)
  end

  # places a piece on the board
  def place_piece(piece, position)
    piece.place_at(position).each do |coords|
      self[coords] = piece
    end
  end

end
