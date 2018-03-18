class ChessPiece

  attr_reader :color, :pic, :starting_pos, :type
  attr_accessor :pos
  def initialize(type, color)
    @type = type
    @color = color
    @starting_pos = true
  end

  def invalid_move?(movement, times)
    send('invalid_' + type.to_s + '?', movement, times)
  end

  def invalid_king?(movement, times)
    if @starting_pos && [:E, :W].include?(movement) && times == 2
      false
    else
      times != 1
    end
  end

  def invalid_queen?(movement, times)
    invalid_rook?(movement, times) and invalid_bishop?(movement, times)
  end

  def invalid_knight?(movement, times)
    movement != :L
  end

  def invalid_rook?(movement, times)
    [:N, :S, :E, :W].include?(movement) == false
  end

  def invalid_bishop?(movement, times)
    [:NE, :NW, :SE, :SW].include?(movement) == false
  end

  def invalid_pawn?(movement, times)
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

  def has_moved
    @starting_pos = false
  end
  
  def to_s
    @pic
  end
end

class King < ChessPiece

  def initialize(type, color)
    super
    @pic = [" \u{2654} ", " \u{265A} "]
  end
end

class Queen < ChessPiece

  def initialize(type, color)
    super
    @pic = [" \u{2655} ", " \u{265B} "]
  end
end

class Knight < ChessPiece

  def initialize(type, color)
    super
    @pic =  [" \u{2658} ", " \u{265E} "]
  end
end

class Rook < ChessPiece

  def initialize(type, color)
    super
    @pic =  [" \u{2656} ", " \u{265C} "]
  end
end

class Bishop < ChessPiece

  def initialize(type, color)
    super
    @pic =  [" \u{2657} ", " \u{265D} "]
  end
end

class Pawn < ChessPiece
  
  def initialize(type, color)
    super
    @pic = [" \u{2659} ", " \u{265F} "]
  end
end
 
