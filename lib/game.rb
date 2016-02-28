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

  private

  def calculate_score
    pnts = @board.clear_filled_rows
    @points += (pnts * pnts)
  end

  def collision?
    cur_pos.any? do |coords|
       hit_bottom?(coords) || hit_other_piece?(next_pos - cur_pos)
    end
  end

  def cur_pos
    @piece.place_at(@cursor_pos)
  end

  def drop
    row, col = @cursor_pos
    @cursor_pos = [row + 1, col]
  end

  def game_over?
    @board.grid[0..3].flatten.any?
  end

  def get_random_piece
    Piece.new [:I,:O,:T,:S,:Z,:J,:L].sample
  end

  def hit_bottom?(coords)
    coords.first.next == @board.grid.length
  end

  def hit_other_piece?(cells)
    cells.each do |cell|
      return true if @board[cell].class == Piece
    end
    false
  end

  def load_stack
    @stack << get_random_piece
  end

  def move
    result = nil
    let_piece_slips = true
    until result
      result = get_input
      @board.move_piece(@piece, @cursor_pos)
      notifications
      break if collision? && check_piece_slip
    end
    result
  end

  def check_piece_slip
    @let_piece_slip = @let_piece_slip ? false : true
  end

  def next_piece
    load_stack
    @stack.shift
  end

  def next_pos
    row, col = @cursor_pos
    @piece.place_at([row + 1, col]).select do |coords|
      @board.in_bounds?(coords)
    end
  end

  def notifications
    system("clear")
    puts "Points: #{@points}"
    puts "Stored Piece: #{@store.inspect}"
    @board.render
    p @stack
  end

  # def start_descent
  #   Thread.new do
  #     while sleep 0.5
  #       drop
  #       notifications
  #       break if collision?
  #     end
  #   end
  # end

  def take_turn
    @piece = next_piece
    @cursor_pos = [2,6]
    # thread = start_descent
    until collision?
      move
    end
    # Thread.kill(thread)
    calculate_score
  end

end
