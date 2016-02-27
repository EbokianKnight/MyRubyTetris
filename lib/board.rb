
class Board
  attr_reader :grid

  # standardized matrix creation
  def self.set_board(width, height)
    Array.new(height){Array.new(width)}
  end

  # starts a new board
  def initialize
    @grid = Board.set_board(10, 24)
  end

  # clears completed rows
  # side-effect: returns number of rows cleared
  def clear_filled_rows
    to_clear = []
    @grid.each_with_index { |row, idx| to_clear << idx if row.all? }
    to_clear.each(&method(:clear_row))
    to_clear.length.times { add_row }
  end

  # moves_selected piece to a new position
  def move_piece(piece, position)
    remove_piece(piece)
    place_piece(piece, position)
  end

  # checks for a valid position
  def in_bounds?(coords)
    row, col = coords
    (0...@grid.first.length).cover?(row) &&
    (0...@grid.length).cover?(col)
  end

  # displays the playable board
  def render
    @grid.take(20).each do |row|
      p row.map{|el| el.nil? ? "  " : el.to_s }.join
    end
    nil
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

  # deletes the piece form the board
  def remove_piece(piece)
    @grid.map! do |row|
      row.map! do |cell|
        cell == piece ? nil : cell
      end
    end
  end

end
