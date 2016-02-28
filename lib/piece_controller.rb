require 'io/console'

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
    space: [-1, 0]
  }

  ROTATOR = {
    up: @piece.rotate! 1,
    down: @piece.rotate! -1
  }

  def handle_key(key)
   case key
   when :ctrl_c, :escape
     exit 0
   when :up, :down
     update_pos(ROTATOR[key])
     nil
   when :return
     @cursor_pos
   when :tab
     @store.swap_store!
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

  def update_pos(diff)
    new_pos = [@cursor_pos[0] + diff[0], @cursor_pos[1] + diff[1]]
    @cursor_pos = new_pos if piece_in_bounds?(new_pos)
  end

  def piece_in_bounds?(new_pos)
    piece.place_at(new_pos).all? { |pos| @board.in_bounds?(pos) }
  end

end
