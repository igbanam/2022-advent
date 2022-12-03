require './helpers.rb'
require 'set'
require 'debug'

include Helpers

def prioritize(character)
  if /[[:upper:]]/.match(character)
    character.ord - 'A'.ord + 27
  else
    character.ord - 'a'.ord + 1
  end
end

data = File.readlines(get_data_file(__FILE__), chomp: true)

priorities = []

data.each do |rucksack|
  sets = []
  raise unless rucksack.size.even?
  midpoint = (rucksack.size / 2.0).round
  rucksack.chars.each_slice(midpoint).each do |group|
    g_set = Set.new
    group.each { |c| g_set << c }
    sets << g_set
  end
  mistake = (sets[0] & sets[1]).to_a.first
  priorities << prioritize(mistake)
end

puts priorities.sum

gets
