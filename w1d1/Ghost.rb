class Game

  attr_accessor :dictionary, :new_d
  def initialize
    clear_game
    @current_player = @p1
    run
  end

  def run

    puts "Player 1, please enter your name"
    @p1= Player.new(gets.chomp.capitalize)
    puts "Player 2, please enter your name"
    @p2= Player.new(gets.chomp.capitalize)
    @current_player = @p1
    puts "GAME START"
    play_round

  end

  def play_round
    puts "#{@current_player.name} please enter a letter"
    @fragment += @current_player.guess
    if is_valid(@fragment) == "lose"
      puts %Q[TOO BAD
            #{@current_player.name} loses the round
            #{@p1.name}'s meter is at #{ghost_converter(@p1.meter)}
            #{@p2.name}'s meter is at #{ghost_converter(@p2.meter)}
            NEW ROUND
            ]

      #####REINITIALIZE THE GAME########
      @current_player.meter += 1
      if @current_player.meter == 5
        puts %Q[#{@current_player.name} gets eaten by ghost
                muahahaha]
      end
      clear_game
      play_round

    elsif is_valid(@fragment) == "continue"
      puts "The current fragment is: #{@fragment}"
      switch_player
      play_round

    else
      @fragment[-1] = ''
      @current_player.alert_invalid_guess
      puts "The current fragment is: #{@fragment}"
      play_round
    end
  end

  def clear_game
    @fragment = ""
    @dictionary = []
    File.open('ghost-dictionary.txt').each { |line| @dictionary << line}
  end

  def switch_player
    @current_player = @current_player == @p1 ? @p2 : @p1
  end

  def is_valid(frag)
    @dictionary = @dictionary.select {|word| frag[frag.length-1] == word[frag.length-1] }
    return "redo" if @dictionary.empty?
    @dictionary.each do |word|
      return "lose" if frag == word.gsub("\n","")
      return "continue"
    end
  end

  def ghost_coverter(number)
    return "G" if number == 1
    return "GH" if number == 2
    return "GHO" if number == 3
    return "GHOS" if number == 4
    return "GHOST" if number == 5
  end
end


class Player

  attr_accessor :name, :meter


  def initialize(name)
    @name = name
    ghost_meter
  end

  def ghost_meter
    @meter = 0
  end



  def guess
    guess = gets.chomp
  end

  def alert_invalid_guess
    puts "you suck"
  end
end

game = Game.new
p game.is_valid('abase')
p game.is_valid('aba')
p game.is_valid('abass')
game.game_start
