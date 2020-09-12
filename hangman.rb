# frozen_string_literal: false
require 'pry'

# class that implements a hangman game
class Hangman
  def initialize(file)
    @word_file = file
    @word = random_word
    @guesses = 0
    @guessed_letters = []
    @board = Array.new(@word.length, '_')
    @player_won = false
  end

  def get_line_from_file(line)
    result = nil

    File.open(@word_file, 'r') do |f|
      while line.positive?
        line -= 1
        result = f.gets.chomp
      end
    end

    result
  end

  def random_word
    word = ''
    line_count = `wc -l "#{@word_file}"`.strip.split(' ')[0].to_i
    word = get_line_from_file(rand(1..line_count)) until word.length > 5 && word.length < 12
    word.downcase
  end

  def display_board
    p @board
  end

  def display_guessed
    puts 'You have guessed these letters:'
    p @guessed_letters
  end

  def player_guess
    puts 'Guess a letter: '
    gets.chomp.downcase
  end

  def check_guess(guess)
    if @word.include? guess
      indexes = (0...@word.length).find_all { |i| @word[i, 1] == guess }
      indexes.each { |index| @board[index] = @word[index] }
    else
      @guessed_letters << guess
      @guesses += 1
    end
    @word == @board.join("")
  end

  def play
    puts @word
    until @player_won || @guesses > 6
      # display number of letters in word
      display_board
      # display guessed chars
      display_guessed
      # ask player to guess a word or a letter
      guess = player_guess
      # check if correct
      @player_won = check_guess(guess)
    end
    @player_won ? puts('Congrats you won') : puts("You lose correct word was: #{@word}")
  end
end

new_game = Hangman.new('5desk.txt')
new_game.play
