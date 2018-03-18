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
    @king = King.new(:king, @color)
    @front_row = Array.new
    8.times { @front_row << Pawn.new(:pawn, @color) }
    @back_row = [Rook.new(:rook, @color),
                 Knight.new(:knight, @color),
                 Bishop.new(:bishop, @color),
                 Queen.new(:queen, @color),
                 king,
                 Bishop.new(:bishop, @color),
                 Knight.new(:knight, @color),
                 Rook.new(:rook, @color)
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

