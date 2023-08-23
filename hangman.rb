# frozen_string_literal: true

require 'tty-prompt'

require_relative 'hangman/game_ui'
require_relative 'hangman/game_state'

class Hangman
  include GameUI
  include GameState

  attr_reader :prompt, :secret_word, :hidden_secret_word,
              :attempts, :correct_guesses, :incorrect_guesses,
              :score

  def initialize(score = 0)
    @prompt = TTY::Prompt.new
    @secret_word = secret_words.sample
    @hidden_secret_word = secret_word.chars.map { '_' }
    @score = score
    @attempts = 6
    @correct_guesses = []
    @incorrect_guesses = []
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

  def gameplay
    prompt.on(:keyescape) { display_pause_menu }

    loop do
      display_in_game_menu

      break if game_over?

      user_input = validate_user_input
      handle_guess(user_input)
    end
    update_score
  end

  def play
    gameplay

    puts won? ? "\nThe dictionary bows before your brilliance!" : "\nThe word eluded your grasp this time."

    sleep 1.5
    next_round?
  end

  private

  def secret_words
    File.read('words.txt').split.select { |word| word.length.between?(5, 12) }
  end

  def reveal_letters(user_input)
    indices = secret_word.length.times.find_all { |idx| secret_word[idx] == user_input }
    indices.each { |idx| hidden_secret_word[idx] = user_input }
  end

  def validate_user_input
    prompt.ask("\nGuess a letter:") do |q|
      q.validate(/\A[a-zA-Z]\z/, 'Please enter a single letter.')
      q.modify :down
    end
  end
end

game = Hangman.new
game.start
