require './helpers.rb'

include Helpers

data = File.readlines(get_data_file(__FILE__), chomp: true)

overlaps = data.map do |line|
  !line.split(',').
    map { |range| range.split('-').map(&:to_i) }.
    map { |d| (d[0]..d[1]).to_a }.
    reduce(&:&).empty?
end

puts overlaps.count { |f| f == true }

gets
