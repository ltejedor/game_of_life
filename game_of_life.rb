class World
	attr_accessor :rows, :cols, :cell_grid

	def initialize(rows=3, cols=3)
		@rows = rows
		@cols = cols

		@cell_grid = Array.new(rows) do |row|
									Array.new(cols) do |call|
										Cell.new
									end
								end

	end

end

class Cell
end