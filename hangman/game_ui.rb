module GameUI
  def display_title_header
    system 'clear'
    puts "\nH A N G M A N"
    puts '_ _ _ _ _ _ _'
  end

  def display_load_game_header
    system 'clear'
    puts '=================================='
    puts '            LOAD GAME'
    puts '=================================='

    return if File.exist?(Hangman::SAVE_FILE_PATH)

    puts "\nThere is no save data."
    sleep 1.5
    start
  end

  def display_pause_menu
    system 'clear'
    puts '=================================='
    puts '           PAUSE MENU'
    puts '=================================='

    choice = prompt.select("\nChoose an option:", ['Resume', 'Save Game', 'Quit'])

    case choice
    when 'Resume' then play
    when 'Save Game' then prompt.yes?('Save game?') ? save_game : display_pause_menu
    when 'Quit' then self.class.new.start
    end
  end

  def display_guesses
    puts "\nCorrect Guesses: #{correct_guesses.uniq.join}\t\tAttempts: #{attempts}"
    puts "Incorrect Guesses: #{incorrect_guesses.uniq.join}\t\tScore: #{score}"
  end

  def display_word_status
    puts lost? ? "\n#{secret_word.chars.join(' ')}" : "\n#{hidden_secret_word.join(' ')}"
  end

  def display_in_game_ui
    system 'clear'
    puts "Press 'Esc' to pause the game."
    display_guesses
    display_word_status
  end
end
