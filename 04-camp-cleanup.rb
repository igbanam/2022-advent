require './helpers.rb'

include Helpers

data = File.readlines(get_data_file(__FILE__), chomp: true)

overlaps = data.map do |line|
  !line.split(',').
    map { |range| range.split('-').map(&:to_i) }.
    map { |range| (range.first..range.last).to_a }.
    reduce(&:intersection).empty?
end

puts overlaps.count { |f| f == true }

gets
