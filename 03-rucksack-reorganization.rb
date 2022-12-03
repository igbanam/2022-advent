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

data.each_slice(3) do |rucksack_group|
  similar = rucksack_group.map(&:chars).reduce(:&)
  priorities << prioritize(similar.first)
end

puts priorities.sum

gets
