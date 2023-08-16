# frozen_string_literal: true

class Hangman
  def initialize; end

  def display_title_screen
    loop do
      system 'clear'
      puts "\nH A N G M A N"
      puts '_ _ _ _ _ _ _'

      sleep 0.5
      puts "\nPress F to Begin"
      sleep 0.5
    end
  end

  def start
    blinking_thread = Thread.new { display_title_screen }

    loop do
      user_input = gets.chomp.downcase
      break if user_input == 'f'
    end

    blinking_thread.kill
    play
  end

  def play
    system 'clear'
    puts 'In-game'
  end
end

game = Hangman.new
game.start
