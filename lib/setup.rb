require_relative 'board'
require_relative 'piece'
require_relative 'player'
require_relative 'game'

p "connected"

b = Board.new
5.times do |i| b[[15,i]]= "#X" end
10.times do |i| b[[16,i]]= "#X" end
3.times do |i| b[[17,i]]= "#X" end
9.times do |i| b[[18,i]]= "#X" end
10.times do |i| b[[19,i]]= "X#" end


a = Piece.new :I
c = Piece.new :Z

b.place_piece(a, [16,8])
c.rotate!
b.place_piece(c, [15,4])

b.render

puts "======================"
b.clear_filled_rows
b.render

puts "======================"
d = Piece.new :Z
b.place_piece d, [2,5]
b.render
puts "======================"
b.move_piece d, [3,5]
b.render
puts "======================"
puts "======================"
b.move_piece d, [4,5]
b.render
puts "======================"
puts "======================"
d.rotate!
b.move_piece d, [5,5]
b.render
puts "======================"
