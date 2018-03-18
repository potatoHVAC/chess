class ChessPiece

  attr_reader :color, :pic, :starting_pos, :type
  attr_accessor :pos
  def initialize(color)
    @color = color
    @starting_pos = true
  end

  def has_moved
    @starting_pos = false
  end
  
  def to_s
    @pic
  end
end


class King < ChessPiece

  def initialize(color)
    super
    @type
    @pic = [" \u{2654} ", " \u{265A} "]
  end

  def invalid_move?(movement, times)
    if @starting_pos && [:E, :W].include?(movement) && times == 2
      false
    else
      times != 1
    end
  end
end


class Queen < ChessPiece

  def initialize(color)
    super
    @type = :queen
    @pic = [" \u{2655} ", " \u{265B} "]
  end

  def invalid_move?(movement, times)
    rook_path = [:N, :S, :E, :W].include?(movement) 
    bishob_path = [:NE, :NW, :SE, :SW].include?(movement)
    false #rook_path and bishob_path
  end
end


class Knight < ChessPiece

  def initialize(color)
    super
    @type = :knight
    @pic =  [" \u{2658} ", " \u{265E} "]
  end

  def invalid_move?(movement, times)
    movement != :L
  end
end


class Rook < ChessPiece

  def initialize(color)
    super
    @type = :rook
    @pic =  [" \u{2656} ", " \u{265C} "]
  end

  def invalid_move?(movement, times)
    [:N, :S, :E, :W].include?(movement) == false
  end
end


class Bishop < ChessPiece

  def initialize(color)
    super
    @type = :bishop
    @pic =  [" \u{2657} ", " \u{265D} "]
  end
  
  def invalid_move?(movement, times)
    [:NE, :NW, :SE, :SW].include?(movement) == false
  end
end


class Pawn < ChessPiece
  
  def initialize(color)
    super
    @type = :pawn
    @pic = [" \u{2659} ", " \u{265F} "]
  end

  def invalid_move?(movement, times)
    case color
    when :white
      if [:NW, :NE, :N].include?(movement) && times == 1
        return false
      elsif @starting_pos && movement == :N && times == 2
        return false
      end        
    else
      if [:SW, :SE, :S].include?(movement) && times == 1
        return false
      elsif @starting_pos && movement == :S && times == 2
        return false
      end
    end

    true
  end
end
 
