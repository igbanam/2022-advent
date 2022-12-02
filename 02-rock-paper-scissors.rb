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
}

def is_rock? played
  %w(A X).include? played
end

def is_paper? played
  %w(B Y).include? played
end

def is_scissors? played
  %w(C Z).include? played
end

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

total = data.map { |e| play(e.split(' ')) }

puts total.sum

gets
