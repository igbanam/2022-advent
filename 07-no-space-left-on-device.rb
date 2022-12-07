require './helpers.rb'
require 'debug'

include Helpers

class Node
  attr_accessor :type, :name, :size, :parent, :children

  def initialize
    @visited = false
    @size = 0
    @children = []
  end

  def register_visit!
    @visited = true
  end

  def clear_visit!
    @visited = false
  end

  def dir?
    type == :dir
  end

  def file?
    type == :file
  end
end

class Filesystem
  attr_reader :root
  attr_accessor :current

  TOTAL_SPACE = 70_000_000
  UPDATE_SPACE = 30_000_000

  def initialize
    @root = Node.new
    @root.type = :dir
    @root.name = '/'
    @root.parent = @root
    @current = @root
  end

  def clean_slate!(node: @root)
    node.clear_visit!
    node.children.each do |child|
      clean_slate!(node: child)
    end
  end

  def to_s(node: @root, representation: [], depth: 0)
    node.register_visit!
    representation << "#{' ' * depth * 2}- #{node.name} #{display_meta(node)}"
    node.children.each do |child|
      to_s(node: child, representation: representation, depth: depth + 1)
    end
    representation.join("\n")
  end

  def display_type(node)
    node.type.to_s
  end

  def display_size(node)
    return "" if node.size <= 0
    "size=#{node.size}"
  end

  def display_meta(node)
    meta = [display_type(node), display_size(node)]
    meta.filter! { |info| info != '' }
    "(#{meta.join(', ')})"
  end

  def add_node(type:, name:, size: 0, parent: @current)

    raise "Parent (#{parent}) is not a node" unless parent.is_a? Node
    raise if type.nil? or name.nil?

    new_node = Node.new
    new_node.type = type
    new_node.name = name
    new_node.size = size
    new_node.parent = parent

    parent.children << new_node
  end

  def find(name, from: @root)
    if name == from.name
      return from
    end
    from.register_visit!
    from.children.each do |child|
      found = find(name, from: child)
      return found unless found.nil?
    end

    nil
  end

  def filter(node: @root, selected: [], &block)
    node.register_visit!
    selected << node if yield(node)
    node.children.each do |child|
      filter(node: child, selected: selected, &block)
    end
    selected
  end

  def descend(into, from: @root)
    candidates = from.children.select { |child| child.name == into }
    raise "No such child folder" if candidates.empty?

    candidates.first
  end

  def rollup_sizes(node: @root)
    node.children.each do |child|
      rollup_sizes(node: child)
    end

    return if node.size.to_i > 0

    node.register_visit!

    node.size = node.children.map(&:size).map(&:to_i).sum
  end
end

data = File.readlines(get_data_file(__FILE__), chomp: true)

filesystem = Filesystem.new

data.each do |line|
  segments = line.split(' ')

  if segments.first == '$'
    segments.shift
    case segments.shift
    when 'cd'
      node_name = segments.shift
      if node_name == '/'
        filesystem.current = filesystem.root
      elsif node_name == '..'
        filesystem.current = filesystem.current.parent
      else
        filesystem.clean_slate!
        filesystem.current = filesystem.descend(node_name, from: filesystem.current)
      end
    when 'ls'
      # do nothing
    else
      raise 'Unknown command'
    end
  else
    if segments.first.to_i == 0
      filesystem.add_node(type: segments.first.to_sym, name: segments.last)
    else
      filesystem.add_node(type: :file, size: segments.first.to_i, name: segments.last)
    end
  end
end

filesystem.rollup_sizes
filesystem.clean_slate!
select_group = filesystem.filter { |n| n.size < 100000 && n.dir? }

puts filesystem
puts
puts select_group.map(&:size).sum

needed_space = Filesystem::UPDATE_SPACE - (Filesystem::TOTAL_SPACE - filesystem.root.size)
biggest_removable = filesystem
  .filter { |n| n.dir? }
  .map { |n| [n.name, n.size, needed_space - n.size] }
  .filter { |d| d.last.negative? }
  .max_by { |d| d.last }[1]
puts biggest_removable

gets
