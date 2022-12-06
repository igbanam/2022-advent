require './helpers.rb'

include Helpers

data = File.readlines(get_data_file(__FILE__), chomp: true)

signal = data.first
WINDOW = 14

signal.chars.each_cons(WINDOW).with_index do |window, index|
  if window.uniq.size == WINDOW
    puts index + WINDOW
    break
  end
end

gets
