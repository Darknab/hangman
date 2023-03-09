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
  attr_accessor :wins, :looses, :current
  attr_reader :name

  def initialize(name, wins = 0, looses = 0, current = {})
    @name = name
    @wins = wins
    @looses = looses
    @current = current
  end

  def update_current(word, result, attempt, incorrect_letters)
    self.current[:word] = word
    self.current[:result] = result
    self.current[:attempt] = attempt
    self.current[:incorrect_letters] = incorrect_letters
    return current
  end

  def round(word, result, incorrect_letters, attempt)
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
    self.update_current(word, result, attempt, incorrect_letters)
    return [result, incorrect_letters]
  end
 
  def game
    word = get_random_word
    puts "word length is #{word.length}"
    result = Array.new(word.length,"-").join("")
    incorrect_letters = []
    attempt = 1
    for attempt in 1 ..8 do
      puts "Attempt #{attempt}"
      answer = round(word, result, incorrect_letters, attempt)
      result = answer[0]
      incorrect_letters = answer[1]
      if result == word
        return "win"
      end
      if attempt == 8
        puts "Game over! the secret word was: #{word}" 
        return "loose"
      end
      puts "Please type C to continue or S to save and exit"
      choice = gets.chomp.downcase
      case choice
      when "c"
        next
      when "s"
        puts "saving: #{self.current}"
        break
      end
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
    case player.game
    when "win"
      player.wins += 1
    when "loose"
      player.looses += 1
    end
    puts "Statistics:    Wins: #{player.wins}    Loses: #{player.looses}"

  elsif response == "no"
    puts "Thanks for playing Hangman!"
    break
  else puts "Sorry I didn't understand, can you repeat please?"
  end
end

 