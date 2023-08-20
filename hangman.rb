# frozen_string_literal: true

require 'tty-prompt'

class Hangman
  attr_reader :prompt, :secret_word, :hidden_secret_word,
              :attempts, :correct_guesses, :incorrect_guesses

  def initialize
    @prompt = TTY::Prompt.new
    @secret_word = secret_words.sample
    @hidden_secret_word = secret_word.chars.map { '_' }
    @attempts = 6
    @correct_guesses = []
    @incorrect_guesses = []
  end

  def secret_words
    File.read('words.txt').split.select { |word| word.length.between?(5, 12) }
  end

  def reveal_letters(user_input)
    indices = secret_word.length
                         .times
                         .find_all { |idx| secret_word[idx] == user_input }

    indices.each do |idx|
      hidden_secret_word[idx] = user_input
    end
  end

  def validate_user_input
    prompt.ask("\nGuess a letter:") do |q|
      q.validate(/\A[a-zA-Z]\z/, 'Please enter a single letter.')
      q.modify :down
    end
  end

  def display_title_screen
    system 'clear'
    puts "\nH A N G M A N"
    puts '_ _ _ _ _ _ _'
  end

  def display_in_game_menu
    system 'clear'

    puts secret_word

    puts "Correct Guesses: #{correct_guesses.uniq.join}"
    puts "Incorrect Guesses: #{incorrect_guesses.uniq.join}"
    puts "Attempts: #{attempts}"
    puts "\n#{hidden_secret_word.join(' ')}"
  end

  def start
    display_title_screen
    choice = prompt.select("\nChoose an option:", ['New Game', 'Load Game', 'Exit'])

    play if choice == 'New Game'
    exit if choice == 'Exit'
  end

  def handle_guess(user_input)
    if secret_word.include?(user_input)
      correct_guesses << user_input
      reveal_letters(user_input)
    else
      @attempts -= 1
      incorrect_guesses << user_input
    end
  end

  def won?
    hidden_secret_word.all? { |element| element.match?(/[[:alpha:]]/) }
  end

  def lost?
    attempts.zero?
  end

  def play
    loop do
      display_in_game_menu

      break if won? || lost?

      user_input = validate_user_input

      handle_guess(user_input)
    end

    puts "\nThe dictionary bows before your brilliance!" if won?
    puts "\nThe word eluded your grasp this time." if lost?
  end
end

game = Hangman.new
game.start
