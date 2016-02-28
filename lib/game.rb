require_relative 'piece_controller'

class Game
  include PieceController

  def initialize
    @board = Board.new
    @store = nil
    @points = 0
    @stack = Array.new(3) { get_random_piece }
  end

  def run
    until game_over?
      take_turn
    end
    puts "GAME OVER"
  end

  def game_over?
    @board.grid[0..3].flatten.any?
  end

  def take_turn
    @piece = next_piece
    @cursor_pos = [2,6]
    until collision?
      move
    end
    @points += @board.clear_filled_rows
  end

  def get_random_piece
    Piece.new [:I,:O,:T,:S,:Z,:J,:L].sample
  end

  def load_stack
    @stack << get_random_piece
  end

  def swap_store!
    if @store.nil?
      @store = @piece
      @board.remove_piece(@piece)
      @piece = next_piece
    else
      @board.remove_piece(@piece)
      @store, @piece = @piece, @store
    end
  end

  def move
    result = nil
    until result
      result = get_input
      debugger if @piece.is_a? Array
      @board.move_piece(@piece, @cursor_pos)
      notifications
      break if collision?
    end
    result
  end

  def current_position
    @piece.place_at(@cursor_pos)
  end

  def next_piece
    load_stack
    @stack.shift
  end

  def next_position
    row, col = @cursor_pos
    @piece.place_at([row + 1, col]).select do |coords|
      @board.in_bounds?(coords)
    end
  end

  def hit_bottom?(coords)
    raise "No Floor Error" if coords.first.next > @board.grid.length
    coords.first.next == @board.grid.length
  end

  def hit_other_piece?
    (next_position - current_position).each do |cell|
      return true if @board[cell].class == Piece
    end
    false
  end

  def drop
    row, col = @cursor_pos
    [row + 1, col]
  end

  def collision?
    current_position.any? do |coords|
       hit_bottom?(coords) || hit_other_piece?
    end
  end

  def notifications
    system("clear")
    puts "Points: #{@points}"
    puts "Stored Piece: #{@store.inspect}"
    @board.render
    p @stack
  end

end
