# frozen_string_literal: true

require 'tty-prompt'
require 'json'

require_relative 'hangman/game_ui'
require_relative 'hangman/game_state'

class Hangman
  include GameUI
  include GameState

  SAVE_FILE_PATH = 'save_data.json'
  MAX_ATTEMPTS = 6

  attr_reader :prompt, :secret_word, :hidden_secret_word,
              :attempts, :correct_guesses, :incorrect_guesses,
              :score

  def initialize(score = 0)
    @prompt = TTY::Prompt.new
    @secret_word = select_secret_word
    @hidden_secret_word = initialize_hidden_secret_word
    @score = score
    @attempts = MAX_ATTEMPTS
    @correct_guesses = []
    @incorrect_guesses = []
  end

  def save_game
    save_data = load_save_data

    save_data << { secret_word:, hidden_secret_word:, correct_guesses:,
                   incorrect_guesses:, score:, attempts: }

    File.open(SAVE_FILE_PATH, 'w') { |file| file.write(JSON.dump(save_data)) }

    sleep 1.5
    puts "\nGame saved successfully!"
    sleep 1.5
    display_pause_menu
  end

  def load_game
    save_data = load_save_data
    filtered_save_data = format_filtered_save_data(save_data) << 'Back'

    display_load_game_header

    choice = prompt.select("\nSelect a saved game to load:", filtered_save_data, per_page: 5)
    start if choice == 'Back'

    selected_save_data = save_data.find { |data| data[:hidden_secret_word].join(' ') == choice.split(' - ')[1] }
    restore_game_state(selected_save_data)

    puts "\nLoading..."
    sleep 1.5
  end

  def start
    display_title_header
    choice = prompt.select("\nChoose an option:", ['New Game', 'Load Game', 'Exit'])

    case choice
    when 'New Game' then play
    when 'Load Game' then load_game
                          play
    when 'Exit' then exit
    end
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
      display_in_game_ui

      break if game_over?

      user_input = prompt_with_validation
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

  def select_secret_word
    secret_words.sample
  end

  def initialize_hidden_secret_word
    Array.new(secret_word.length, '_')
  end

  def reveal_letters(user_input)
    indices = secret_word.length.times.find_all { |idx| secret_word[idx] == user_input }
    indices.each { |idx| hidden_secret_word[idx] = user_input }
  end

  def prompt_with_validation
    prompt.ask("\nGuess a letter:") do |q|
      q.validate(/\A[a-zA-Z]\z/, 'Please enter a single letter.')
      q.modify :down
    end
  end

  def load_save_data
    File.exist?(SAVE_FILE_PATH) ? JSON.parse(File.read(SAVE_FILE_PATH), symbolize_names: true) : []
  end
end

game = Hangman.new
game.start
