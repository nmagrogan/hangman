# frozen_string_literal: false
require 'pry'

require 'msgpack'

SAVE_FILE = 'save.dat'.freeze

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
    @word == @board.join('')
  end

  def check_to_save
    puts 'Would you like to save the game?(y/n): '
    choice = gets.chomp.downcase
    choice == 'y'
  end

  def check_for_save
    if File.file?(SAVE_FILE)
      puts 'Would you like to load data from a saved game?(y/n)'
      choice = gets.chomp.downcase
      choice == 'y'
    end
  end

  def turn
    display_guessed
    guess = player_guess
    @player_won = check_guess(guess)
    display_board
    if check_to_save
      save
      true
    elsif @guesses > 6 || @player_won
      true
    else
      false
    end
  end

  def save
    save_file = File.open(SAVE_FILE, 'w')
    save_file.puts to_msgpack
    save_file.close
    puts 'Your game has been saved'
  end

  def play
    puts @word
    gameover = false
    #from_msgpack(SAVE_FILE) if check_for_save

    display_board
    #until gameover
      #gameover = turn
    #end

    if @player_won
      puts 'Congrats you won'
    elsif @guesses > 6
      puts "You lose correct word was: #{@word}"
    end
  end

  def to_msgpack
    MessagePack.dump({
      word: @word,
      guesses: @guesses,
      guessed_letters: @guessed_letters,
      board: @board,
      player_won: @player_won
      })
  end

  def from_msgpack(filename)
    data = MessagePack.load filename
    @word = data['word']
    @guesses = data['guesses']
    @guessed_letters = data['guessed_letters']
    @board = data['board']
    @player_won = data['player_won']
  end
end

new_game = Hangman.new('5desk.txt')

new_game.play
