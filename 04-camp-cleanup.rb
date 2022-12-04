require './helpers.rb'

include Helpers

class ElfRange
  attr_accessor :from, :to
  def fully_contains? elf_range
    from <= elf_range.from && to >= elf_range.to
  end
end

data = File.readlines(get_data_file(__FILE__))
containers = 0

data.each do |line|
  ranges = line.split(',').map do |range|
    bounds = range.split('-').map(&:to_i)
    elf_range = ElfRange.new
    elf_range.from = bounds.first
    elf_range.to = bounds.last
    elf_range
  end

  if ranges.first.fully_contains?(ranges.last) || ranges.last.fully_contains?(ranges.first)
    containers += 1
  end
end

puts containers

gets
