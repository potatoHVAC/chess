class Tile

  attr_accessor :N, :NW, :W, :SW, :S, :SE, :E, :NE, :pos, :data, :color
  def initialize(pos)
    @pos = pos
  end

  def update_pos
    if @data
      @data.pos = pos
    end
    self
  end

  def to_s
    if color == :white
      if @data
        if @data.color == :white
          @data.pic[1].blue.bg_green
        else
          @data.pic[1].red.bg_green
        end
      else
        '   '.bg_green
      end
    else
      if @data
        if @data.color == :white
          @data.pic[1].blue.bg_magenta
        else
          @data.pic[1].red.bg_magenta
        end
      else
        '   '.bg_magenta
      end
    end
  end
    

  def add_color(x)
    x.even? ? @color = :white : @color = :black
    self
  end
  
  def neighbor(dir)
    case dir
    when :N
      self.N
    when :NE
      self.NE
    when :E
      self.E
    when :SE
      self.SE
    when :S
      self.S
    when :SW
      self.SW
    when :W
      self.W
    when :NW
      self.NW
    end
  end
  
  def insert(piece)
    @data = piece
  end

  def swap_with(dest_tile)
    self.data, dest_tile.data = dest_tile.data, self.data
  end

  def same_color?(attacker_color)
    return false if self.data.nil?
    attacker_color == data.color
  end

  def obstructed_path?(movement, times)
    return false if movement == :L || times == 1
    return true if send(movement.to_s).data
    send(movement.to_s).obstructed_path?(movement, times - 1)
  end
end

class Board

  attr_accessor :tile_arr
  def initialize(size)
    @size = size
    @tile_arr = populate_board
  end

  def update_pos
    @tile_arr.each do |col|
      col.each { |tile| tile.update_pos }
    end
    self
  end
  
  def populate_board
    board = Array.new(@size)
    for y in 0...@size
      col = Array.new(@size)
      for x in 0...@size
        col[x] = Tile.new([x, y]).add_color(x + y)
      end
      board[y] = col
    end

    populate_relationships(board)
  end

  def insert(pos, piece)
    self.get_tile(pos).insert(piece)
  end
  
  def get_tile(pos, board = @tile_arr)
    x , y = pos
    return nil if x < 0 || y < 0 || x >= @size || y >= @size
    board[y][x]
  end

  def populate_relationships(board)
    board = board.each do |col|
      col.each do |tile|
        x, y = tile.pos
        tile.N = get_tile([x, y + 1], board)
        tile.NE = get_tile([x + 1, y + 1], board)
        tile.E = get_tile([x + 1, y], board)
        tile.SE = get_tile([x + 1, y - 1], board)
        tile.S = get_tile([x, y - 1], board)
        tile.SW = get_tile([x - 1, y - 1], board)
        tile.W = get_tile([x - 1, y], board)
        tile.NW = get_tile([x - 1, y + 1], board)
      end
    end
    
    board
  end
  
  def to_s
    row_count = 1
    rows = @tile_arr.map do |row|
      head = ' ' + row_count.to_s + '   '
      row_str = row.map do |tile|
        tile.to_s
      end.join()
      
      row_count += 1
      head + row_str      
    end.reverse
    bottom = ' +--- a  b  c  d  e  f  g  h'
    [' ', rows, ' |', bottom, ' '].join("\n")
  end
end

