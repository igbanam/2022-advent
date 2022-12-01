# Find the elf carrying the most calories

require './helpers.rb'

include Helpers

data = File.readlines(get_data_file(__FILE__), chomp: true)
elf_calories = []
all_calories = []

data.each do |calorie|
  if calorie == ''
    all_calories << elf_calories
    elf_calories = []
  end

  elf_calories << calorie.to_i
end

puts all_calories.map { |e| e.sum }.max
