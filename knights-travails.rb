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

  def traverse_graph(start, dest)
    puts "Looking for #{start} to #{dest} path"

    seed = { pos: start, distance: 0, parent: nil, children: @adj_list[start] }

    queue = [seed]
    visited = []
    parents = {}
    steps = []

    puts "Starting at #{start}"

    puts "First cab off the rank: #{queue.inspect}"

    visited << start

    while queue.any?

      current_node = queue.shift

      puts "Current node: #{current_node[:pos]}"

      steps << current_node if current_node[:pos] != start

      if current_node[:pos] == dest
        puts "Shortest path to #{dest} is #{current_node[:distance]} moves"
        path = build_path(parents, dest)
        puts "Steps: #{path.inspect}"
        return
      end

      @adj_list[current_node[:pos]].each do |neighbour|
        next if visited.include?(neighbour)

        puts "Looking at neighbour #{neighbour}"
        queue << { pos: neighbour, distance: current_node[:distance] + 1, parent: current_node[:pos] }
        puts 'Added to queue'
        puts queue.inspect
        visited << neighbour
        parents[neighbour] = current_node[:pos]
      end
      # puts build_path(parents, dest, start)

      # neighbour_node = {}
      # neighbour_node[:children] = @adj_list[key[:pos]]

      # neighbour_node[:children].each do |neighbour|
      #   next if visited.include?(neighbour)

      #   puts "Looking at neighbour #{neighbour}"
      #   queue << { pos: neighbour, distance: key[:distance] + 1, parent: key[:pos] }
      #   puts 'Added to queue'
      #   puts queue.inspect
      #   visited << neighbour
      #   parents[neighbour] = neighbour_node
      # end

    end
  end

  def build_path(parents, dest)
    path = [dest]

    while parents[dest]
      dest = parents[dest]
      path.unshift(dest)
    end
    path
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

dest = [5, 5]
knight.move(dest)

knight.adj_list.each { |k, v| puts "#{k}: #{v}" }

knight.traverse_graph(start, dest)

# knight.dfs_path(start, dest)
