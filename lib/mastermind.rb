class Code
  PEGS = {
    "R" => :red,
    "G" => :green,
    "B" => :blue,
    "Y" => :yellow,
    "O" => :orange,
    "P" => :purple
  }

  attr_reader :pegs

  def initialize(pegs)
    @pegs = pegs
  end

  def self.parse(input)
    unless input.upcase.chars.all? { |c| PEGS.include?(c) }
      raise ArgumentError, "Invalid input."
    end
    Code.new(input.upcase.split(""))
  end

  def self.random
    random_pegs = PEGS.keys.sample(4)
    Code.new(random_pegs)
  end

  def [](index)
    pegs[index]
  end

  def ==(code_guess)
    return false unless code_guess.is_a?(Code)

    self.pegs == code_guess.pegs
  end

  def exact_matches(code_guess)
    count = 0
    pegs.each_index do |i|
      count += 1 if self[i] == code_guess[i]
    end
    count
  end

  def near_matches(code_guess)
    count = 0
    pegs.uniq.each do |peg|
      count += [pegs.count(peg), code_guess.pegs.count(peg)].min
    end

    count - self.exact_matches(code_guess)
  end
end

class Game
  attr_reader :secret_code

  def initialize(secret_code = Code.random)
    @secret_code = secret_code
  end

  def play
    10.times do
      guess = get_guess

      if guess == secret_code
        puts "You won!"
        return
      end

      display_matches(guess)
    end

    puts "Womp womp. You ran out of guesses."
  end

  def get_guess
    print "Please enter a guess: "
    Code.parse(gets.chomp)
  rescue
    puts "Invalid input!"
    retry
  end

  def display_matches(guess)
    puts "You got #{secret_code.exact_matches(guess)} exact matches!"
    puts "You got #{secret_code.near_matches(guess)} near matches!"
  end
end

if $0 == __FILE__
  Game.new.play
end
