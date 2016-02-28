require 'io/console'

char = 'a'

Thread.new { print char while sleep 0.1 }

while char = STDIN.getch
  break if char == ?q
end

Thread.new do
  while sleep 0.3
    drop
    break if collision?
  end
end
