require 'gosu'
require_relative 'game_of_life.rb'

class GameOfLifeWindow < Gosu::Window

	def initialize(height = 800, width = 600)
		@height = height
		@width = width
		super height, width, false
		self.caption = "Game of Life"

		@background_color = Gosu::Color.new(155, 155, 160)
		@alive_color = Gosu::Color.new(23, 192, 230)
		@dead_color = Gosu::Color.new(255, 255, 255)

		# game itself
		@rows = height/7
		@cols = width/7

		@col_width = width/@cols
		@row_height = height/@rows

		@world = World.new(@cols, @rows)
		@game = Game.new(@world)
		@game.world.randomly_populate

	end

	def update
		@game.tick!
	end

	def draw
		draw_quad(0, 0, @background_color,
							width, 0, @background_color,
							width, height, @background_color,
							0, height, @background_color)

		@game.world.cells.each do |cell|
			if cell.alive?

				draw_quad(cell.x * @col_width, cell.y * @row_height, @alive_color,
										(cell.x * @col_width) + (@col_width - 1), cell.y * @row_height, @alive_color,
										(cell.x * @col_width) + (@col_width - 1), cell.y * @row_height + (@row_height - 1), @alive_color,
										cell.x * @col_width, (cell.y * @row_height) + (@row_height - 1), @alive_color)

			else
				draw_quad(cell.x * @col_width, cell.y * @row_height, @dead_color,
									cell.x * @col_width + (@col_width - 1), cell.y * @row_height, @dead_color,
									cell.x * @col_width + (@col_width - 1), cell.y * @row_height + (@row_height - 1), @dead_color,
									cell.x * @col_width, cell.y * @row_height + (@row_height - 1), @dead_color)
			end
		end
	end

	def needs_cursor?; true; end

end

window = GameOfLifeWindow.new
window.show