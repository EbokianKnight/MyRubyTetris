require 'colorize'

class Piece
  attr_reader :shape

  Color = {
    I: :blue,
    O: :cyan,
    T: :yellow,
    S: :red,
    Z: :green,
    J: :light_black,
    L: :magenta
  }

  Rotations = {
    O: [
        [[0,0],[0,-1],[-1,-1],[-1,0]]
        ],
    I: [
        [[0,0],[0,-2],[0,-1],[0,1]],
        [[0,0],[1,0],[-1,0],[-2,0]]
        ],
    S: [
        [[0,0],[0,1],[-1,-1],[-1,0]],
        [[0,0],[1,0],[0,1],[-1,1]]
        ],
    Z: [
        [[0,0],[0,-1],[-1,0],[-1,1]],
        [[0,0],[1,1],[0,1],[-1,0]]
        ],
    J: [
        [[0,0],[0,1],[0,-1],[-1,-1]],
        [[0,0],[1,0],[-1,0],[-1,1]],
        [[0,0],[0,-1],[1,1],[0,1]],
        [[0,0],[1,-1],[1,0],[-1,0]]
       ],
    L: [
        [[0,0],[0,-1],[0,1],[-1,1]],
        [[0,0],[1,0],[-1,0],[1,1]],
        [[0,0],[1,-1],[0,-1],[0,1]],
        [[0,0],[-1,-1],[-1,0],[1,0]]
        ],
    T: [
        [[0,0],[0,-1],[0,1],[-1,0]],
        [[0,0],[1,0],[-1,0],[0,1]],
        [[0,0],[1,0],[0,-1],[0,1]],
        [[0,0],[1,0],[0,-1],[-1,0]]
        ],
  }

  def initialize(shape)
    @shape = shape
    @positions = Rotations[shape]
    current_position
  end

  def inspect
    @shape
  end

  def to_s
    "██".colorize(Color[@shape])
  end

  def current_position
    @current_position = @positions.first
  end

  def rotate!(num)
    @positions.rotate!(num)
    current_position
  end

  def rotate(num)
    @positions.rotate.first
  end

  def place_at(coord)
    row_mod, col_mod = coord
    current_position.map do |row, col|
      [row + row_mod, col + col_mod]
    end
  end

end
