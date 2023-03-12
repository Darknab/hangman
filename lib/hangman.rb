require 'yaml'

def get_random_word
  word = String.new
  loop do
    word = File.readlines('google-10000-english-no-swears.txt').sample.strip
    break if word.length >= 4 && word.length < 13
  end
  word
end

def set_new_game
  word = get_random_word
  result = Array.new(word.length, '-').join('')
  current = {
    word: word,
    result: result,
    attempt: 1,
    incorrect_letters: []
  }
end

def print_result(word, result, incorrect_letters)
  if result == word
    puts 'Congratulations! you guessed the secret word!'
  else
    puts "#{result} incorrect letters: #{incorrect_letters.join(',')}"
  end
end

class Hangman
  attr_accessor :wins, :looses, :current, :name

  def initialize(name, wins = 0, looses = 0, current = {})
    @name = name
    @wins = wins
    @looses = looses
    @current = current
  end

  def update_current(word, result, attempt, incorrect_letters)
    current[:word] = word
    current[:result] = result
    current[:attempt] = attempt
    current[:incorrect_letters] = incorrect_letters
    current
  end

  def save_game
    filename = "saves/#{name}.yaml"
    File.open(filename, 'w') { |file| file.write(to_yaml) }
  end

  def round(word, result, incorrect_letters, attempt)
    guess = String.new

    loop do
      puts 'Please enter a letter'
      guess = gets.chomp
      break if guess != '0' && guess.length == 1 && guess.to_i == 0

      puts 'Incorrect letter, please try again'
    end

    if word.include?(guess)
      word.split('').each_with_index do |letter, index|
        result[index] = letter if letter == guess
      end
    else
      incorrect_letters.append(guess)
    end

    print_result(word, result, incorrect_letters)
    update_current(word, result, attempt, incorrect_letters)
    [result, incorrect_letters]
  end

  def game(current)
    word = current[:word]
    result = current[:result]
    puts result
    incorrect_letters = current[:incorrect_letters]
    attempt = current[:attempt]
    loop do
      puts "Attempt #{attempt}"
      answer = round(word, result, incorrect_letters, attempt)
      result = answer[0]
      incorrect_letters = answer[1]
      return 'win' if result == word
      attempt += 1
      if attempt == 9
        puts "Game over! the secret word was: #{word}"
        return 'loose'
      end
      puts 'type exit to save and exit or any key to continue'
      choice = gets.chomp.downcase
      next unless choice == 'exit'

      save_game
      break
    end
  end

  def to_yaml
    YAML.dump({
                name: @name,
                wins: @wins,
                looses: @looses,
                current: @current
              })
  end

  def self.from_yaml(save)
    data = YAML.load save
    new(
      data[:name],
      data[:wins],
      data[:looses],
      data[:current]
    )
  end
end

puts 'Welcome to Hangman!'
puts 'What is your name?'
input = gets.chomp.capitalize

if File.exist?("saves/#{input}.yaml")
  save = File.read("saves/#{input}.yaml")
  player = Hangman.from_yaml(save)
  puts "Welcome back, #{player.name}!"
  puts "your statistics are:    Wins: #{player.wins}    Loses: #{player.looses}"
  p player.current
  if player.current[:attempt] != 1
    puts 'Do you want to continue your previous game?'
    ans = gets.chomp.downcase
    if ans == 'yes'
      current = player.current
    else
      current = set_new_game
    end
  else
    current = set_new_game
  end

else
  player = Hangman.new(input)
  puts "Welcome, #{player.name}!"
  current = set_new_game
end
loop do
  puts 'Do you want to play?(yes/no)'
  response = gets.chomp.downcase
  if response == 'yes'

    case player.game(current)
    when 'win'
      player.wins += 1
      player.update_current('', '', 1, [])

    when 'loose'
      player.looses += 1
      player.update_current('', '', 1, [])

    end
    player.save_game
    puts "Statistics:    Wins: #{player.wins}    Loses: #{player.looses}"

  elsif response == 'no'
    puts 'Thanks for playing Hangman!'
    player.save_game
    break
  else
    puts "Sorry I didn't understand, can you repeat please?"
  end
end
