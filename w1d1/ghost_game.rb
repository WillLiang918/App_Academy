class Game
  def initialize(p1, p2)
    @p1 = p1
    @p2 = p2
    @current_player = @p1
    clear_game
    @losses = {p1: 0, p2: 0}
  end

  def run
    until @losses.values.include?(5)
      clear_game
      play_round
    end
    puts "#{@current_player.name} Lost"
  end

  def clear_game
    @fragment = ""
    @dictionary = []
    File.open('ghost-dictionary.txt').each { |line| @dictionary << line}
    @new_d = @dictionary
  end

  def play_round
    until over?
      take_turn(@current_player)
      next_player!
    end
    next_player!
    if @current_player == @p1
      @losses[:p1] += 1
      puts "#{@current_player.name} score: #{"GHOST"[0...@losses[:p1]]}"
    else
      @losses[:p2] += 1
      puts "#{@current_player.name} score: #{"GHOST"[0...@losses[:p2]]}"
    end
  end

  def take_turn(player)
    guess = @current_player.guess
    if valid_play?(@fragment + guess)
      @new_d = @new_d.select { |word| word[@fragment.length] == guess }
      @fragment << guess
      puts "The new word is #{@fragment}"
    else
      @current_player.alert_invalid_guess
      take_turn(@current_player)
    end
  end

  def next_player!
    @current_player = @current_player == @p1 ? @p2 : @p1
  end

  def over?
    @new_d.each do |word|
      return true if word.gsub("\n", '') == @fragment
    end
    false
  end

  def valid_play?(string)
    valid_array = @new_d.select { |word| word[0..@fragment.length] == string}
    true unless valid_array.empty?
  end
end

class Player

  attr_accessor :name, :score
  def initialize(name)
    @name = name
    @score = 0
  end

  def guess
    puts "#{self.name} please enter a guess"
    gets.chomp
  end

  def get_score
    @score += 1
    "GHOST"[0...@score]
  end

  def alert_invalid_guess
    puts "This is not a word\n\n"
  end
end

player_1 = Player.new("Will")
player_2 = Player.new("Computer")
game = Game.new(player_1, player_2)
game.run
