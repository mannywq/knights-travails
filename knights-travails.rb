class Knight
  attr_accessor :options, :adj_list, :visited

  def initialize(pos = [0, 0], colour = 'white')
    @color = colour
    @pos = pos
    @options = []
    @visited = []
    @adj_list = {}
    @rows = 8
    @cols = 8
    @graph = {}

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

  def create_graph(rows, cols)
    @graph ||= {}

    (0...rows).each do |row|
      (0...cols).each do |col|
        pos = [row, col]
        # puts "Key is #{pos.inspect}"
        #

        # puts "At #{pos.inspect}"

        neighbours = get_possible_moves(pos)

        # puts "Found #{neighbours.inspect}"

        add_edge(pos, neighbours)
        # puts @graph[pos].inspect
      end
    end
    # Spot checking graph is properly working - puts @graph[[5, 7]].inspect
  end

  def add_edge(pos, neighbours)
    @graph[pos] ||= []
    @graph[pos] = neighbours
  end

  def get_possible_moves(pos)
    options = []

    @moves.each do |move|
      y = (pos[0] + move[0])
      x = (pos[1] + move[1])

      next unless y.between?(0, 7) && x.between?(0, 7)

      options << [y, x]
    end
    # puts "Options #{options.inspect} Length: #{options.length}"
    options
  end

  def traverse_graph(start, dest)
    puts "Looking for #{start} to #{dest} path"

    parents = {}
    distance = {}

    puts "Starting at #{start}"

    @graph.keys.each { |node| distance[node] = Float::INFINITY }

    distance[start] = 0

    puts distance

    queue = @graph.keys.clone

    while queue.any?

      current_node = queue.min_by { |node| distance[node] }

      puts "Current node: #{current_node}"

      queue.delete(current_node)

      # Found goal?
      if current_node == dest
        path = []
        while parents[current_node]
          path.unshift(current_node)
          current_node = parents[current_node]
        end
        path.unshift(start)
        puts "Made it in #{path.length - 1} moves"
        puts 'Moves: '
        path.each_with_index { |el, i| puts "#{i}: #{el}" }
        return path
      end

      # Explore neighbours
      puts "Current node distance is: #{distance[current_node]}"
      @graph[current_node].each do |neighbour|
        # next if visited.include?(neighbour)
        alt = distance[current_node] + 1

        next unless alt < distance[neighbour]

        distance[neighbour] = alt
        parents[neighbour] = current_node
      end

    end
  end
end
start = [0, 0]

knight = Knight.new(start)

knight.create_graph(8, 8)

dest = [5, 7]

knight.traverse_graph(start, dest)
