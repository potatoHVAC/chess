require_relative './player.rb'
require_relative './board.rb'
require_relative './chess_piece.rb'

class Game

  attr_accessor :players, :game_over, :board
  def initialize(p1, p2)
    @players = [Player.new(:white, p1), Player.new(:black, p2)]

    @board = populate_pieces(Board.new(8))

    @history = []
    @game_over = false
    @turn = 0
  end

  def other(player)
    @players.find { |x| x != player }
  end
  
  def populate_pieces(game_board)
    players[1].insert_pieces(players[0].insert_pieces(game_board)).update_pos
  end

  def play
    puts self
    player_move(@players[@turn % 2])
    @turn += 1
    if game_over
      exit
    end
    play
  end
  
  def player_move(player)
    first_input = get_input("#{player.color}: ")
          
    tile = board.get_tile(xy_converter(first_input))
    if tile.data.nil? || tile.data.color != player.color
      puts "--must select a #{player.color.to_s} piece"
      return player_move(player)
    end

    second_input = get_input("#{tile.data.type} to: ")

    move_responce = move(player, first_input, second_input)
    if move_responce.is_a?(Action)
      @history << move_responce
    else
      puts move_responce
      player_move(player)
    end
  end

  def get_input(str)
    print str
    input = gets.strip
    
    if bad_input?(input)
      puts "--invalid input, try again: "
      get_input(str)
    else
      input
    end
  end

  def bad_input?(str)
    str.length != 2 || /[^1-8]/.match(str[1].downcase) || /[^a-h]/.match(str[0])
  end
  
  def move(player, source_str, dest_str)
    source_pos = xy_converter(source_str)
    dest_pos = xy_converter(dest_str)
    source_tile = board.get_tile(source_pos)
    dest_tile = board.get_tile(dest_pos)
    piece = source_tile.data
    target = dest_tile.data
    movement, times = parse_dir(source_pos, dest_pos, piece)

    error_message = check_movement(player, source_pos, dest_pos, source_tile, dest_tile, piece, movement, times)
    return error_message if error_message

    if promote_pawn?(piece, dest_pos)
      piece = source_tile.data = player.promote_pawn
    end

    if castling?(piece, movement, times)
      castle_action(piece, source_tile, dest_tile, movement)
    else
      backup = @board.dup
      
      self.capture(dest_tile)
      source_tile.swap_with(dest_tile)
      dest_tile.update_pos
      
      piece.has_moved
      Action.new(piece, source_str, dest_str, target)
    end
  end

  def check_movement(player, source_pos, dest_pos, source_tile, dest_tile, piece, movement, times)
    if source_pos == dest_pos
      "--cannot start and end on same tile"
    elsif dest_tile.same_color?(player.color)
      "--cannot capture your own piece"
    elsif movement == :invalid
      "--invalid movement"
    elsif source_tile.obstructed_path?(movement, times)
      "--path obstructed"
    elsif piece.invalid_move?(movement, times)
      "--invalid #{piece.type.to_s} movement" 
    elsif piece.type == :pawn
      if [:N, :S].include?(movement) && source_tile.obstructed_path?(movement, times + 1)
        return "--pawns cannot capture forwards" 
      elsif [:NW, :NE, :SW, :SE].include?(movement) && dest_tile.data.nil?
        return "--pawns can only move diagonally when capturing"
      end
    else
      false
    end
  end

  def promote_pawn?(piece, dest_pos)
    piece.type == :pawn && [0, 7].include?(dest_pos[1])
  end
  
  def get_piece(pos)
    tile = board.get_tile(pos)
    tile.data.type
  end
  
  def xy_converter(pos)
    return pos if pos.is_a?(Array)
    x , y = pos.downcase.split('')    
    [x.downcase.tr('abcdefgh','01234567').to_i, y.to_i - 1]
  end

  def capture(target_tile)
    if target_tile.data
      case target_tile.data.color
      when :white
        players[0].cap(target_tile.data)
      else
        players[1].cap(target_tile.data)
      end

      target_tile.data = nil
    end
  end

  def castling?(piece, movement, times)
    piece.type == :king && [:W, :E].include?(movement) && times == 2
  end

  def castle_action(piece, source_tile, dest_tile, movement)
    movement == :E ? distance = 3 : distance = 4
    rook_tile, rook_movement = get_castle_rook(piece, movement)

    return "--rook must be in starting position" if rook_tile.data.nil? && rook.startin_pos == false
    return "--casteling path must be clear" if rook_tile.obstructed_path?(rook_movement, distance)
    
    source_tile.swap_with(dest_tile)
    rook_tile.swap_with(dest_tile.neighbor(rook_movement))
    Action.new(piece, 'start_pos', "castle #{movement.to_s}", nil)
  end

  def get_castle_rook(piece, movement)
    if piece.color == :white
      if movement == :E
        [board.get_tile([7,0]), :W]
      else
        [board.get_tile([0,0]), :E]
      end
    else
      if movement == :E
        [board.get_tile([7,7]), :W]
      else
        [board.get_tile([0,7]), :E]
      end
    end
  end
  
  def parse_dir(start_pos, finish_pos, piece)
    # returns the cardinal direction and number of steps to get there.
    # returns [:L, 1] if Knight movement
    
    delta_x = finish_pos[0] - start_pos[0]
    delta_y = finish_pos[1] - start_pos[1]
    dist = delta_x.abs + delta_y.abs
    
    if dist == 3 and piece.type == :knight and not ( delta_x.zero? or delta_y.zero? )
      [:L, 1]
    elsif delta_x.zero?
      if delta_y.positive?
        [:N, delta_y]
      else
        [:S, delta_y.abs]
      end
    elsif delta_y.zero?
      if delta_x.positive?
        [:E, delta_x]
      else
        [:W, delta_x.abs]
      end
    elsif delta_x == delta_y
      if delta_x.positive?
        [:NE, delta_x]
      else
        [:SW, delta_x.abs]
      end
    elsif delta_x.abs == delta_y.abs
      if delta_x.positive?
        [:SE, delta_x]
      else
        [:NW, delta_y]
      end
    else
       :invalid
    end    
  end
  
  def to_s
    @board.to_s
  end

  def show_history
    p @history.length
    @history.map { |action| action.to_s }.join("\n")
  end
end

class Action

  attr_reader :piece, :source_str, :dest_str, :captured
  def initialize(piece, source_str, dest_str, cap)
    @piece = piece
    @source_str = source_str
    @dest_str = dest_str
    @captured = cap
  end

  def to_s
    captured ? str = 'captures' : str = 'to'
    [piece.color.to_s, piece.type.to_s, str, dest_str].join(' ')
  end
end

class String

  def black;          "\e[30m#{self}\e[0m" end
  def red;            "\e[31m#{self}\e[0m" end
  def green;          "\e[32m#{self}\e[0m" end
  def brown;          "\e[33m#{self}\e[0m" end
  def blue;           "\e[34m#{self}\e[0m" end
  def magenta;        "\e[35m#{self}\e[0m" end
  def cyan;           "\e[36m#{self}\e[0m" end
  def gray;           "\e[37m#{self}\e[0m" end

  def bg_black;       "\e[40m#{self}\e[0m" end
  def bg_red;         "\e[41m#{self}\e[0m" end
  def bg_green;       "\e[42m#{self}\e[0m" end
  def bg_brown;       "\e[43m#{self}\e[0m" end
  def bg_blue;        "\e[44m#{self}\e[0m" end
  def bg_magenta;     "\e[45m#{self}\e[0m" end
  def bg_cyan;        "\e[46m#{self}\e[0m" end
  def bg_gray;        "\e[47m#{self}\e[0m" end

  def bold;           "\e[1m#{self}\e[22m" end
end
