class Knight
  attr_accessor :options, :adj_list, :visited

  def initialize(pos = [0, 0])
    @pos = pos
    @rows = 8
    @cols = 8
    # Stores the whole board and possible moves from each x, y coordinate
    @graph = {}

    @moves = [[1, 2], [2, 1], [1, -2], [2, -1], [-1, 2], [-2, 1], [-1, -2], [-2, -1]]
  end

  # Creates game board and links for knight piece
  def create_graph(rows, cols)
    @graph ||= {}

    (0...rows).each do |row|
      (0...cols).each do |col|
        # Temporary var to store current coords
        pos = [row, col]

        # Get all possible moves from current coords
        neighbours = get_possible_moves(pos)

        # @graph[pos] = [neighbours]
        add_edge(pos, neighbours)
      end
    end
  end

  def add_edge(pos, neighbours)
    @graph[pos] ||= []
    @graph[pos] = neighbours
  end

  # Get all reachable places from current position within the size of the board
  def get_possible_moves(pos)
    options = []

    # Add move coords to current pos and check if within bounds
    @moves.each do |move|
      y = (pos[0] + move[0])
      x = (pos[1] + move[1])

      next unless y.between?(0, 7) && x.between?(0, 7)

      options << [y, x]
    end
    # Return options array
    options
  end

  def traverse_graph(start, dest)
    # Store the previous node in each path and distance from each node to start node
    parents = {}
    distance = {}

    # Initialise the distance hash with graph key and infinity as initial value
    @graph.keys.each { |node| distance[node] = Float::INFINITY }

    # Start node has 0 distance
    distance[start] = 0

    # Clone graph to create a priority queue
    queue = @graph.keys.clone

    while queue.any?

      # Grab the node that matches the minimum distance value
      current_node = queue.min_by { |node| distance[node] }

      # Get rid of the node from queue so we don't go back to it
      queue.delete(current_node)

      # Base condition: Found the destination?
      if current_node == dest
        path = []

        # Back track through parents until we get back to the start and push to start of array
        while parents[current_node]
          path.unshift(current_node)
          current_node = parents[current_node]
        end

        # Finally add start node to path
        path.unshift(start)
        puts "Made it in #{path.length - 1} moves"
        puts 'Moves: '
        path.each_with_index { |el, i| puts "#{i}: #{el}" }
        return path
      end

      # Explore neighbours
      # puts "Current node distance is: #{distance[current_node]}"
      @graph[current_node].each do |neighbour|
        # Each neighbour gets a distance value of current_node + 1
        alt = distance[current_node] + 1

        # Keep going until we find a shorter distance
        next unless alt < distance[neighbour]

        # Update distance of node to temp alt value
        distance[neighbour] = alt
        parents[neighbour] = current_node
      end

    end
  end
end
