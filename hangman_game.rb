# frozen_string_literal: true

# Hangman rules
class HangmanGame
  def initialize
    @secret_word = ''
    @blank_word = nil
    @dictionary = File.new('google-10000-english-no-swears.txt')
    @mistakes = 0
    @wrong_guesses = []
  end

  # This function randomly select a word between 5 and 12 characters long for the secret word
  def select_word
    valid_word = false
    while valid_word != true
      randint = Random.new
      index = randint.rand(0..9893)
      word = @dictionary.readlines[index].chomp
      word.length >= 5 && word.length <= 12 ? valid_word = true : @dictionary.rewind
    end
    @secret_word = word.upcase.split('')
    @blank_word = Array.new(@secret_word.length, '_')
  end

  # draw stick figure to show incorrect guesses and secret word letters _ R _ W (correct and incorrect letters)
  def draw
    stick_figure = File.new('hangman_ascii_art.txt').readlines[@mistakes]
    puts stick_figure.gsub!('\n', "\n")
    puts "Secret word: #{@blank_word.join('  ')} | Errors: #{@mistakes} | Wrong Guesses: #{@wrong_guesses.join(', ')}"
  end

  # player input a letter, if the letter is in the secret word blank word is updated, otherwise add to wrong_guess ls
  def play
    wrong = true
    print 'Ingresar letra: '
    guess = gets.chomp.upcase
    @secret_word.each_with_index do |letter, index|
      next unless guess == letter

      wrong = false
      @blank_word[index] = guess
    end
    return unless wrong == true

    puts "There is no letter #{guess} in the secret word"
    @wrong_guesses << guess
    @mistakes += 1
  end

  def did_i_lost?
    @mistakes == 6
  end

  def did_i_win?
    @secret_word == @blank_word
  end

  def message(condition)
    victory = "Congrats! You won the secret word was #{@secret_word.join(' ')}"
    defeat = "You lost! The secret word was #{@secret_word.join(' ')}"
    if condition == true
      puts victory
    else
      puts defeat
    end
  end
end

def start_game(round)
  round.select_word
  condition = false
  while round.did_i_lost? == false && round.did_i_win? == false
    round.draw
    round.play
    condition = round.did_i_win?
  end
  round.draw
  round.message(condition)
end

game_round = HangmanGame.new
start_game(game_round)
