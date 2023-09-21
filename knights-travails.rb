class Knight
  attr_accessor :options, :adj_list, :visited

  def initialize(pos = [0, 0], colour = 'white')
    @color = colour
    @pos = pos
    @options = []
    @visited = []
    @adj_list = {}

    @moves = [
      [1, 2],
      [2, 1],
      [1, -2],
      [2, -1],
      [-1, 2],
      [-2, 1],
      [-1, -2],
      [-2, -1]
    ]
  end

  def add_edge(u, v)
    @adj_list[u] ||= []
    @adj_list[u] << v
    @adj_list[v] ||= []
    @adj_list[v] << u
  end

  def get_possible_moves
    options = []

    @moves.each do |move|
      y = (@pos[0] + move[0])
      x = (@pos[1] + move[1])

      next unless y.between?(0, 7) && x.between?(0, 7) && @visited.none?([y, x])

      options << [y, x]
    end
    # puts "Options #{options.inspect} Length: #{options.length}"
    options
  end

  def build_path(start, dest)
    puts "Looking for #{start} to #{dest} path"
    queue = []
    visited = []

    puts "Starting at #{start}"

    queue.concat(@adj_list[start])

    puts "First cab off the rank: #{queue.inspect}"

    while queue.any?

      key = queue.shift

      next if visited.include?(key)

      node = @adj_list[key]
      if key == dest
        puts "Shortest path to #{dest} is #{visited.length} moves"
        puts path_string(visited)

        return
      end

      # puts "Current node key: #{key} children: #{node}"
      visited << key

      if node == dest
        puts 'Found path!'
        puts visited
      end

      node.each do |child|
        queue << child
      end

    end
  end

  def dfs_path(start, dest, visited = [], depth = 1)
    visited ||= []
    max_depth ||= 8

    return if depth == max_depth

    puts "Current node: #{start} - searching for #{dest}"

    if start == dest
      puts "Found #{node} at #{depth}"
      puts visited.inspect
    end

    visited << start

    node = @adj_list[start]

    node.each do |child|
      dfs_path(child, dest, visited, depth + 1) unless visited.include?(child)
    end
    visited.pop
  end

  def path_string(arr)
    arr.map(&:to_s)
  end

  def move(dest)
    queue = [@pos]
    puts queue.inspect
    moves = 0

    options = get_possible_moves

    queue.concat(options)

    while queue.any?

      y, x = queue.shift

      next if @visited.include?([y, x])

      # puts "Y is #{y}"
      # puts "X is #{x}"

      unless valid_move?([y, x])
        # puts "#{[y, x]} not a valid move from #{@pos.inspect}}"
        next
      end

      add_edge([y, x], @pos) unless @adj_list.key?([y, x])
      @visited << [y, x]
      @pos = [y, x]
      # puts "pos is now #{@pos}"
      moves += 1
      options = get_possible_moves

      queue.concat(options)

      next unless @pos == dest

      puts "Arrived at #{dest} - position is #{@pos}"
      puts "Done in #{moves} moves"
      return moves

    end
    puts 'No path found'
  end

  def valid_move?(move_arr)
    return nil if move_arr.length != 2

    diff_y = move_arr[0] - @pos[0]
    diff_x = move_arr[1] - @pos[1]

    return true if @moves.include?([diff_y, diff_x])

    false
  end
end

# class Board
#   attr_accessor :board
#
#   def initialize
#     @board = Array.new(8) { Array.new(8) { Node.new } }
#     @nodes = {}
#   end
#
#   def print_board
#     for i in 0...@board.length
#       for j in 0...@board.length
#         if (i + j).even?
#           print "\e[47m #{@board[i][j]} \e[0m"
#         else
#           print "\e[40m #{@board[i][j]} \e[0m"
#         end
#       end
#       print "\n"
#     end
#   end
# end
#
# class Node
#   def initialize(name = 'node')
#     @name = name
#     @children = []
#   end
#
#   def add_edge(child)
#     @children << child
#   end
# end

start = [0, 0]
knight = Knight.new(start)

knight.get_possible_moves

dest = [4, 5]
knight.move(dest)

# knight.adj_list.each { |k, v| puts "#{k}: #{v}" }

# knight.build_path(start, dest)

knight.dfs_path(start, dest)
