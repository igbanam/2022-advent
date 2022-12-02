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

def play hands
  # first is opponent
  # last is you
  opponent_played = weigh(hands.first)
  user_played = weigh(hands.last)
  result = nil

  if opponent_played == user_played
    result = @scores[:draw]
  elsif opponent_played == @weight[:scissors] && user_played == @weight[:rock]
    result = @scores[:win]
  elsif opponent_played == @weight[:rock] && user_played == @weight[:scissors]
    result = @scores[:lose]
  elsif opponent_played < user_played
    result = @scores[:win]
  else
    result = @scores[:lose]
  end

  result + user_played
end

total = data.map { |e| play(e.split(' ')) }

puts total.sum

gets
