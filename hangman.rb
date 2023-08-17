# frozen_string_literal: true

class Hangman
  attr_reader :secret_word

  def initialize
    @secret_word = secret_words.sample
  end

  def secret_words
    File.read('words.txt').split.select { |word| word.length.between?(5, 12) }
  end

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
