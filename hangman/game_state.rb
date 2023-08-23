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
    prompt.yes?("\nPlay again?") ? self.class.new(@score).play : exit
  end
end
