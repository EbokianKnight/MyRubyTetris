require_relative 'board'
require_relative 'piece'
require_relative 'player'
require_relative 'game'

p "connected"

if __FILE__ == $PROGRAM_NAME
  Game.new.run
end
