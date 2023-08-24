module GameState
  def won?
    hidden_secret_word.all? { |element| element.match?(/[[:alpha:]]/) }
  end

  def lost?
    attempts.zero?
  end

  def game_over?
    won? || lost?
  end

  def update_score
    @score += 1 if won?
  end

  def next_round?
    @score = 0 if lost?
    prompt.yes?("\nPlay again?") ? self.class.new(@score).play : self.class.new.start
  end

  def format_filtered_save_data(save_data)
    save_data.map.with_index do |data, idx|
      "Save Slot #{idx + 1} - #{data.fetch(:hidden_secret_word).join(' ')}"
    end
  end

  def restore_game_state(selected_save_data)
    @secret_word = selected_save_data[:secret_word]
    @hidden_secret_word = selected_save_data[:hidden_secret_word]
    @correct_guesses = selected_save_data[:correct_guesses]
    @incorrect_guesses = selected_save_data[:incorrect_guesses]
    @score = selected_save_data[:score]
    @attempts = selected_save_data[:attempts]
  end
end
