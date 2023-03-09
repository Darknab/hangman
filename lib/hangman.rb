def get_random_word
  word = String.new
  unless word.length >= 6 && word.length < 15 
    word = File.readlines("google-10000-english-no-swears.txt").sample.strip
  end
  word
end

def print_result(word, result, incorrect_letters)
  if result == word
    puts "Congratulations! you guessed the secret word!"
  else puts "#{result} incorrect letters: #{incorrect_letters.join(",")}"
  end
end

class Hangman
  attr_reader :name

  def initialize(name, wins = 0, loses = 0)
    @name = name
    @wins = wins
    @loses = loses
  end

  def round(word, result, incorrect_letters)
    guess = String.new
  
    loop do 
      puts "Please enter a letter"
      guess = gets.chomp
      if guess != "0" && guess.length == 1 && guess.to_i == 0
        break
      else puts "Incorrect letter, please try again"
      end
    end
  
    if word.include?(guess)
      word.split("").each_with_index do |letter, index|
        result[index] = letter if letter == guess
      end
    else incorrect_letters.append(guess)
    end
    
    print_result(word, result, incorrect_letters)
  
    return [result, incorrect_letters]
  end
  
  def game
    word = get_random_word
    puts "word length is #{word.length}"
    result = Array.new(word.length,"-").join("")
    incorrect_letters = []
    i = 1
    for i in 1 ..8 do
      puts "Round #{i}"
      answer = round(word, result, incorrect_letters)
      result = answer[0]
      incorrect_letters = answer[1]
      break if result == word
      puts "Game over! the secret word was: #{word}" if i == 8
    end
  end
end

puts "Welcome to Hangman!"
puts "What is your name?"
input = gets.chomp.capitalize

player = Hangman.new(input)

puts "Welcome, #{player.name}!"
loop do
  puts "Do you want to start a new game?(yes/no)"
  response = gets.chomp.downcase
  if response == "yes"
    player.game
  elsif response == "no"
    puts "All right, see you next time ;)"
    break
  else puts "Sorry I didn't understand, can you repeat please?"
  end
end