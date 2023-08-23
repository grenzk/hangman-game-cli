module GameUI
  def display_title_screen
    system 'clear'
    puts "\nH A N G M A N"
    puts '_ _ _ _ _ _ _'
  end

  def display_pause_menu
    system 'clear'
    puts '=================================='
    puts '           PAUSE MENU'
    puts '=================================='

    choice = prompt.select("\nChoose an option:", ['Resume', 'Save Game', 'Quit'])

    gameplay if choice == 'Resume'
    self.class.new.start if choice == 'Quit'
  end

  def display_in_game_menu
    system 'clear'
    puts "Press 'Esc' to pause the game."
    puts secret_word

    puts "\nCorrect Guesses: #{correct_guesses.uniq.join}\t\tAttempts: #{attempts}"
    puts "Incorrect Guesses: #{incorrect_guesses.uniq.join}\t\tScore: #{score}"
    puts "\n#{hidden_secret_word.join(' ')}"
  end
end
