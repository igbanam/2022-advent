# Rock Paper Scissors

require './helpers.rb'

include Helpers

data = File.readlines(get_data_file(__FILE__), chomp: true)

@scores = {
  win: 6,
  draw: 3,
  lose: 0
}

@weight = {
  rock: 1,
  paper: 2,
  scissors: 3
}

@strategy = {
  part_1: ->(moves) {
    opponent = weigh(moves.first)
    user = weigh(moves.last)
    if opponent == user
      result = @scores[:draw]
    elsif opponent == @weight[:scissors] && user == @weight[:rock]
      result = @scores[:win]
    elsif opponent == @weight[:rock] && user == @weight[:scissors]
      result = @scores[:lose]
    elsif opponent < user
      result = @scores[:win]
    else
      result = @scores[:lose]
    end
    return result + user
  },
  part_2: ->(guide) {
    opponent = guide.first
    expected = guide.last

    raise "Unknown instruction" unless %w( X Y Z ).include?(expected)

    case
    when to_win?(expected)
      user_play = weigh(opponent) + 1
      user_play = user_play % 3 if user_play > 3
      result = @scores[:win]
    when to_draw?(expected)
      user_play = weigh(opponent)
      result = @scores[:draw]
    when to_lose?(expected)
      user_play = weigh(opponent) - 1
      user_play = 3 + user_play if user_play < 1
      result = @scores[:lose]
    end

    return result + user_play
  }
}

def is_rock? played
  %w(A X).include? played
end
alias :to_lose? :is_rock?

def is_paper? played
  %w(B Y).include? played
end
alias :to_draw? :is_paper?

def is_scissors? played
  %w(C Z).include? played
end
alias :to_win? :is_scissors?

def weigh played
  case
  when is_rock?(played)
    @weight[:rock]
  when is_paper?(played)
    @weight[:paper]
  when is_scissors?(played)
    @weight[:scissors]
  else
    raise 'Played an unknown hand.'
  end
end

def play hands, strategy: @strategy[:part_1]
  strategy.call(hands)
end

total = data.map { |e| play(e.split(' '), strategy: @strategy[:part_2]) }

puts total.sum

gets
