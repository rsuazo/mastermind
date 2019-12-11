class Game
  attr_reader :key, :hint, :current_player_id, :turns
  attr_accessor :code

  def initialize(player_1_class, player_2_class)
    @code = []
    @key = Array.new(5)
    @hint = Array.new(4)
    @turns = 2

    @current_player_id = 0
    @players = [player_1_class.new(self), player_2_class.new(self)]
  end

  def play

    while @turns > 0
      code = generate_player_code(current_player)

      switch_players!
      break if win?(play_turn(current_player, code))
      switch_players!
     
      @turns -= 1
    end


  end

  def play_turn(current_player, code)
    key = generate_player_key(current_player)
    temp_key = key
    temp_code = code

    i = 0
    j = 0
    
    while i < 4

      while j < 4
        if temp_code[i] == temp_key[j]
          if i == j
            @hint[i] = "Red"  
            temp_code[i] = "a"
            temp_key[j] = "b"
          else
              @hint[i] = "White"
              temp_code[i] = "a"
              temp_key[j] = "b"
          end
        end  
          j += 1
      end
      j = 0
      i += 1
    end
    puts "You got the following correct guesses: #{@hint.shuffle}"
    @hint
  end

  def win?(hint)
    if @hint.all? { |hint| hint == "Red"}
      puts "You Win!"
      puts "Game Over!"
      return true
      #winning condition
    else
      puts "Try again!"
      other_player.score += 1
      puts  other_player.score
      #increment to next turn
    end
    
  end


  def generate_player_code(player)
    player.generate_code!

  end
  
  def generate_player_key(player)
    key = player.generate_key!
    return key
  end

  def switch_players!
    @current_player_id = other_player_id
  end

  def current_player
    @players[current_player_id]
  end

  def other_player
    @players[other_player_id]
  end

  def other_player_id
    1 - @current_player_id
  end


end

class Player
  attr_accessor :game, :role, :score
  
  def initialize(game)
    @game = game
    @role = role
    @score = 0
  end

end

class HumanPlayer < Player

  def place_peg(peg_class)
    
  end


  def generate_key!
    i = 1
    key = []
    while i < 5 do
      print "\n\nSelect your KeyPeg for Position #{i}: (Red, Blue, Green, Yellow, Black, White, or Blank)"
      key << gets.chomp
      i += 1
    end
    return key
  end

  def to_s
    "Human"
  end

end

class ComputerPlayer < Player
  
  def generate_code!
    
    colors = {
      1 => "Red", 
      2 => "Blue", 
      3 => "Green", 
      4 => "Yellow", 
      5 => "Black", 
      6 => "White", 
      7 => "Blank"
    }

    code = []
    i = 0
    
    while i < 4
      code << colors[rand(7)+1]
      i += 1
    end

    print code
    code
  end
end



Game.new(ComputerPlayer, HumanPlayer).play