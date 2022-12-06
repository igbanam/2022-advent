require './helpers.rb'

include Helpers

data = File.readlines(get_data_file(__FILE__), chomp: true)

split = data.index('')

# The `crates =` bit below may be a bit confusing. This is what I'm trying to
# achieve here. We have the crates specification as a visual representation. I
# want to take this, and make it a list of arrays with the zeroth element at the
# bottom. This way, `crates[0][0]` in the puzzle input is 'S', and
# `crates[8][0]` should be H.
#
# This is a miniature ETL of sorts. I'll explain each step as a comment

crates = data[0..(split - 2)]          # crates lines; without indices
  .map(&:chars)                        # explode each line to its chars
  .map do | k |                        # for each such line
    k.each_slice(4)                    # chunk the chars by 4; i.e. [['[','A',']',' '], ...]
      .map(&:join)                     # recreate the letter; ['[A] ', ...]
      .map(&:strip)                    # remove trailing spaces; ['[A]', ...]
  end
  .transpose                           # this is where the magic happens
  .map(&:reverse)                      # set the array uup bottom-up
  .map do |f|                          # for each of these crates…
    f.delete_if { |g| g.empty? }       # remove the likes of ['', ...]
      .map { |f| f.gsub(/[\[\]]/,'') } # convert ['[A]'] -> ['A']
  end

instructions = data[(split + 1)..]

instructions.each do |instruction|
  instruction.scan(/move (\d+) from (\d+) to (\d+)/) do |amount, from, to|
    crates[to.to_i - 1].push(crates[from.to_i - 1].pop(amount.to_i)).flatten!
  end
end

puts crates.map(&:last).join

gets
