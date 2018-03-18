class ChessPiece

  attr_reader :type, :color, :pic, :starting_pos
  attr_accessor :pos
  def initialize(type, color)
    @type = type
    @color = color

    case type
    when :king
      @pic = [" \u{2654} ", " \u{265A} "]
      @starting_pos = true
    when :queen
      @pic = [" \u{2655} ", " \u{265B} "]
    when :knight
      @pic =  [" \u{2658} ", " \u{265E} "]
    when :rook
      @pic =  [" \u{2656} ", " \u{265C} "]
      @starting_pos = true
    when :bishop
      @pic =  [" \u{2657} ", " \u{265D} "]
    when :pawn
      @pic = [" \u{2659} ", " \u{265F} "]
      @starting_pos = true
    end
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

