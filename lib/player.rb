class Player

  attr_reader :color, :name, :king
  attr_accessor :front_row, :back_row, :dead
  def initialize(color, name)
    @name = name
    @color = color
    @dead = []

    generate_lineup
  end

  def generate_lineup
    @king = King.new(color)
    @front_row = Array.new
    8.times { @front_row << Pawn.new(color) }
    @back_row = [Rook.new(color),
                 Knight.new(color),
                 Bishop.new(color),
                 Queen.new(color),
                 king,
                 Bishop.new(color),
                 Knight.new(color),
                 Rook.new(color)
                ]
  end

  def insert_pieces(board)
    case self.color
    when :black
      front_row.each_with_index { |piece, i| board.insert([i, 6], piece) }
      back_row.each_with_index { |piece, i| board.insert([i, 7], piece) }
    else
      front_row.each_with_index { |piece, i| board.insert([i, 1], piece) }
      back_row.each_with_index { |piece, i| board.insert([i, 0], piece) }
    end
    
    board    
  end
  
  def cap(piece)
    if piece.type == :pawn
      @front_row.reject! {|p| p == piece }
    else
      piece.has_moved
      @back_row.reject! {|p| p == piece }
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
    @back_row << piece
    piece
  end
  
  def to_s
    [@front_row.map(&:to_s).join(" "), @back_row.map(&:to_s).join(" ")].join("\n")
  end
      
end

