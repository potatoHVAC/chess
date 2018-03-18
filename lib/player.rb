class Player

  attr_reader :color, :name, :king
  attr_accessor :army, :dead
  def initialize(color, name)
    @name = name
    @color = color
    @dead = []

    @army = generate_lineup
  end

  def generate_lineup
    @king = King.new(color)
    pawn_row = Array.new
    8.times { pawn_row << Pawn.new(color) }
    royal_row = [Rook.new(color),
                 Knight.new(color),
                 Bishop.new(color),
                 Queen.new(color),
                 king,
                 Bishop.new(color),
                 Knight.new(color),
                 Rook.new(color)]
    [pawn_row, royal_row]
  end

  def insert_pieces(board)
    case self.color
    when :black
      army[0].each_with_index { |piece, i| board.insert([i, 6], piece) }
      army[1].each_with_index { |piece, i| board.insert([i, 7], piece) }
    else
      army[0].each_with_index { |piece, i| board.insert([i, 1], piece) }
      army[1].each_with_index { |piece, i| board.insert([i, 0], piece) }
    end
    
    board    
  end
  
  def cap(piece)
    if piece.type == :pawn
      @army[0].reject! {|p| p == piece }
    else
      piece.has_moved
      @army[1].reject! {|p| p == piece }
      @dead << piece
    end
  end

  def promote_pawn
    if @dead.any?
      puts @dead.map.with_index { |piece,i| "#{i + 1}:#{piece.to_s}" }.join(' ')
      print "select promotion: "
      revive(@dead[gets.strip.to_i - 1])
    end
  end

  def revive(piece)
    @dead.reject! {|p| p == piece }
    @army[1] << piece
    piece
  end
  
  def to_s
    [army.map(&:to_s).join(" ")].join("\n")
  end  
end

