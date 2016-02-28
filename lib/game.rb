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
    # thread = start_descent
    until game_over?
      take_turn
    end
    # Thread.kill(thread)
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

  def game_over?
    @board.grid[0..3].flatten.any?
  end

  def get_random_piece
    Piece.new [:I,:O,:T,:S,:Z,:J,:L].sample
  end

  def load_stack
    @stack << get_random_piece
  end

  def move
    result = nil
    until result
      result = get_input
      @board.move_piece(@piece, @cursor_pos)
      display_screen
      break if collision? && toggle_piece_slip
    end
    result
  end

  def next_piece
    load_stack
    @stack.shift
  end

  def display_screen
    system("clear")
    puts "Points: #{@points}"
    puts "Stored Piece: #{@store.inspect}"
    @board.render
    p @stack
  end

  # def start_descent
  #   Thread.new do
  #     while sleep 0.2
  #       STDIN.cooked!
  #       update_pos(MOVES[:space]) if @piece
  #       display_screen
  #       STDIN.raw!
  #     end
  #   end
  # end

  def take_turn
    @piece = next_piece
    @cursor_pos = [2,6]
    until collision?
      @let_piece_slip = true
      move
    end
    calculate_score
  end

  def toggle_piece_slip
    @let_piece_slip = @let_piece_slip ? false : true
  end

end
