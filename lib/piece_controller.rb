require 'io/console'
require 'byebug'

module PieceController

  KEYMAP = {
    " " => :space,
    "w" => :up,
    "a" => :left,
    "s" => :down,
    "d" => :right,
    "\t" => :tab,
    "\r" => :return,
    "\n" => :newline,
    "\e[A" => :up,
    "\e[B" => :down,
    "\e[C" => :right,
    "\e[D" => :left,
    "\e" => :escape,
    "\u0003" => :ctrl_c,
  }

  MOVES = {
    left: [0, -1],
    right: [0, 1],
    space: [1, 0]
  }

  ROTATOR = {
    up: 1,
    down: -1
  }

  def handle_key(key)
   case key
   when :ctrl_c, :escape
     exit 0
   when :up, :down
     update_rotation(ROTATOR[key])
     nil
   when :return
     @cursor_pos
   when :tab
     swap_store!
   when :left, :right, :space
     update_pos(MOVES[key])
     nil
   else
     puts key
   end
  end

  def get_input
   key = KEYMAP[read_char]
   handle_key(key)
  end

  def read_char
   STDIN.echo = false
   STDIN.raw!

   input = STDIN.getc.chr
   if input == "\e" then
     input << STDIN.read_nonblock(3) rescue nil
     input << STDIN.read_nonblock(2) rescue nil
   end
  ensure
   STDIN.echo = true
   STDIN.cooked!

   return input
  end

  def collision?
    down = get_pos(MOVES[:space])
    invalid_move?(down)
  end

  def cells_at(pos = @cursor_pos)
    @piece.place_at(pos)
  end

  def get_pos(diff)
    [@cursor_pos[0] + diff[0], @cursor_pos[1] + diff[1]]
  end

  def hit_other_piece?(new_pos)
    cells = cells_at(new_pos)
    cells.any? do |cell|
      @board[cell].is_a?(Piece) &&
      @board[cell] != @piece
    end
  end

  def check_cells(new_pos)
    cells_at(new_pos).select do |coords|
      @board.in_bounds?(coords)
    end
  end

  def piece_in_bounds?(new_pos)
    cells_at(new_pos).all? { |pos| @board.in_bounds?(pos) }
  end

  def update_pos(diff)
    new_pos = get_pos(diff)
    @cursor_pos = new_pos if valid_move?(new_pos)
  end

  def update_rotation(num)
    @piece.rotate!(num)
    unless piece_in_bounds?(@cursor_pos)
      @piece.rotate!(num * -1) unless wall_kick?
    end
  end

  def valid_move?(new_pos)
    piece_in_bounds?(new_pos) && !hit_other_piece?(new_pos)
  end

  def invalid_move?(new_pos)
    !valid_move?(new_pos)
  end

  def wall_kick?
    right = get_pos(MOVES[:right])
    left = get_pos(MOVES[:left])

    if valid_move?(right)
      update_pos MOVES[:right]
    elsif valid_move?(left)
      update_pos MOVES[:left]
    else
      nil
    end
  end

end
