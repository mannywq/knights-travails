require_relative './lib/knights-travails'

start = [0, 0]

knight = Knight.new(start)

knight.create_graph(8, 8)

dest = [5, 7]

knight.traverse_graph(start, dest)
