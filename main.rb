require_relative './lib/game.rb'


def test1
  puts 'test1'
  test1 = Game.new('dan', 'pete')
  puts test1
  test1.move(test1.players[1], 'd7', 'd5')
  test1.move(test1.players[0], 'b1', 'a3')
  puts test1
  test1.move(test1.players[1], 'c8', 'f5')
  test1.move(test1.players[1], 'e7', 'e6')
  test1.move(test1.players[1], 'f8', 'a3')
  test1.move(test1.players[1], 'd8', 'h4')
  test1.move(test1.players[0], 'b2', 'a3')
  test1.move(test1.players[0], 'h2', 'h3')
  puts test1
end

def test2
  puts "test2"
  
  test2 = Game.new("tom", "harry")
  puts test2

end

def test3
  test3 = Game.new('Dan', 'Pete')
  test3.play
end

def test4
  test4 = Game.new('dan', 'pete')
  p1 = test4.players[0]
  p2 = test4.players[1]
  test4.capture(test4.board.get_tile([1,0]))
  test4.capture(test4.board.get_tile([2,0]))
  test4.capture(test4.board.get_tile([3,0]))
  test4.capture(test4.board.get_tile([5,0]))
  test4.capture(test4.board.get_tile([6,0]))
  puts test4.move(p1, 'e1', 'c1')
  puts test4
  test4.capture(test4.board.get_tile([1,7]))
  test4.capture(test4.board.get_tile([2,7]))
  test4.capture(test4.board.get_tile([3,7]))
  test4.capture(test4.board.get_tile([5,7]))
  test4.capture(test4.board.get_tile([6,7]))
  puts test4.move(p2, 'e8', 'g8')
  puts test4
end

test2
