# frozen_string_literal: true

class Hangman
  attr_reader :secret_word, :hidden_secret_word,
              :attempts, :incorrect_guesses

  def initialize
    @secret_word = secret_words.sample
    @hidden_secret_word = secret_word.chars.map { '_' }
    @attempts = 6
    @incorrect_guesses = []
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

  def display_in_game_menu
    system 'clear'

    puts secret_word

    puts 'Correct Guesses:'
    puts "Incorrect Guesses: #{incorrect_guesses.join}"
    puts "Attempts: #{attempts}"
    puts "\n#{hidden_secret_word.join(' ')}"
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
    loop do
      display_in_game_menu

      print "\nGuess a letter: "
      user_input = gets.chomp.downcase
      if secret_word.include?(user_input)

        indices = secret_word.length
                             .times
                             .find_all { |idx| secret_word[idx] == user_input }

        indices.each do |idx|
          hidden_secret_word[idx] = user_input
        end
      else
        @attempts -= 1
        incorrect_guesses << user_input
      end
    end
  end
end

game = Hangman.new
game.start
