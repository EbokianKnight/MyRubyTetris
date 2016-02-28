require_relative 'piece_controller'

class Game
  extend PieceController

  def initialize(piece, board)
    @piece = get_random_piece
    @board = board
    @store = []
  end

  def get_random_piece
    Piece.new [:I,:O,:T,:S,:Z,:J,:L].sample
  end

  def swap_store!
    if @store.empty?
      @store << @piece
      @piece = get_random_piece
    else
      @store, @piece = @piece, @store
    end
  end

  def move
    result = nil
    until result
      system("clear")
      @cursor_pos = [5,5]
      @board.render
      @board.move_piece(@piece, @cursor_pos)
      result = get_input
    end
    result
  end



end
