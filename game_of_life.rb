class Game
	attr_accessor :world, :seeds

	def initialize(world=World.new, seeds=[])
		@world = world
		@seeds = seeds

		seeds.each do |seed|
			world.cell_grid[seed[0]][seed[1]].alive = true
		end
	end

	def tick!
		next_round_live_cells = []
		next_round_dead_cells = []

		world.cells.each do |cell|
			#Rule #1
			if cell.alive? and world.live_neighbors_around_cell(cell).count < 2
				next_round_dead_cells << cell
			end
			#Rule #2
			if cell.alive? and ([2, 3].include? world.live_neighbors_around_cell(cell).count)
				next_round_live_cells << cell
			end
			#Rule #3
			if cell.alive? and world.live_neighbors_around_cell(cell).count > 3
				next_round_dead_cells << cell
			end
			#Rule #4
			if cell.dead? and world.live_neighbors_around_cell(cell).count == 3
				next_round_live_cells << cell
			end
		end

		next_round_live_cells.each do |cell|
			cell.live!
		end

		next_round_dead_cells.each do |cell|
			cell.die!
		end
	end

end

class World
	attr_accessor :rows, :cols, :cell_grid, :cells

	def initialize(rows=3, cols=3)
		@rows = rows
		@cols = cols
		@cells = []

		@cell_grid = Array.new(rows) do |row|
									Array.new(cols) do |col|
										cell = Cell.new(col, row)
										cells << cell
										cell
									end
								end

	end

	def live_neighbors_around_cell(cell)
		live_neighbors = []
		# neighbor to the North
		if cell.y > 0
			candidate = self.cell_grid[cell.y - 1][cell.x]
			live_neighbors << candidate if candidate.alive?
		end

		#neighbor to the north-west
		if cell.y > 0 and cell.x > 0
			candidate = self.cell_grid[cell.y - 1][cell.x - 1]
			live_neighbors << candidate if candidate.alive?
		end

		#neighbor to the north-east
		if cell.y > 0 and cell.x < (cols - 1)
			candidate = self.cell_grid[cell.y - 1][cell.x + 1]
			live_neighbors << candidate if candidate.alive?
		end

		#neighbor to the south-east
		if cell.y < (rows - 1) and cell.x < (cols - 1)
			candidate = self.cell_grid[cell.y + 1][cell.x + 1]
			live_neighbors << candidate if candidate.alive?
		end

		#neighbor to the south-west
		if cell.y < (rows - 1) and cell.x > 0
			candidate = self.cell_grid[cell.y + 1][cell.x - 1]
			live_neighbors << candidate if candidate.alive?
		end

		#neighbour to the east
		if cell.x < (cols - 1)
			candidate = self.cell_grid[cell.y][cell.x + 1]
			live_neighbors << candidate if candidate.alive?
		end

		#neighbor to the south
		if cell.y < (rows - 1)
			candidate = self.cell_grid[cell.y + 1][cell.x]
			live_neighbors << candidate if candidate.alive?
		end

		#neighbor to the west
		if cell.x > 0
			candidate = self.cell_grid[cell.y][cell.x - 1]
			live_neighbors << candidate if candidate.alive?
		end

		live_neighbors
	end

end

class Cell
	attr_accessor :alive, :x, :y

	def initialize(x=0, y=0)
		@alive = false
		@x = x
		@y = y
	end

	def alive?; alive; end

	def dead?; !alive; end

	def die!
		@alive = false
	end

	def live!
		@alive = true
	end
end