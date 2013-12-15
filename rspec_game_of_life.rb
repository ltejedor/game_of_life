require 'rspec'
require_relative 'game_of_life.rb'

describe 'Game of life' do

	let!(:world) { World.new }
	let!(:cell) { Cell.new(1, 1) }

	context 'World' do
		subject { World.new }

		it 'should create a new world object' do
			subject.is_a?(World).should be_true
		end

		it "should respond to proper methods" do
			subject.should respond_to(:rows)
			subject.should respond_to(:cols)
			subject.should respond_to(:cell_grid)
			subject.should respond_to(:live_neighbors_around_cell)
			subject.should respond_to(:cells)
			subject.should respond_to(:randomly_populate)
			subject.should respond_to(:live_cells)
		end

		it "should create proper cel grid on initialization" do
			subject.cell_grid.is_a?(Array).should be_true

			subject.cell_grid.each do |row|
				row.is_a?(Array).should be_true
				row.each do |col|
					col.is_a?(Cell).should be_true
				end
			end

		end

		it "should add all cells to cells array" do
			subject.cells.count.should == 9
		end

		it "should detect a neighbor to the north" do
			subject.cell_grid[0][1].should be_dead
			subject.cell_grid[0][1].alive = true
			subject.cell_grid[0][1].should be_alive
			subject.live_neighbors_around_cell(subject.cell_grid[1][1]).count.should == 1
		end
		it "detects live neighbor to the north-east" do
			subject.cell_grid[cell.y - 1][cell.x + 1].alive = true
			subject.live_neighbors_around_cell(cell).count.should == 1
		end
		it "detects live neighbor to the east" do
			subject.cell_grid[cell.y][cell.x + 1].alive = true
			subject.live_neighbors_around_cell(cell).count.should == 1
		end
		it "detects live neighbour to the south-east" do
			subject.cell_grid[cell.y + 1][cell.x + 1].alive = true
			subject.live_neighbors_around_cell(cell).count.should == 1
		end
		it "detects live neighbor to the south" do
			subject.cell_grid[cell.y + 1][cell.x].alive = true
			subject.live_neighbors_around_cell(cell).count.should == 1
		end
		it "detects live neighbor to the south-west" do
			subject.cell_grid[cell.y + 1][cell.x - 1].alive = true
			subject.live_neighbors_around_cell(cell).count.should == 1
		end
		it "detects live neighbor to the west" do
			subject.cell_grid[cell.y][cell.x - 1].alive = true
			subject.live_neighbors_around_cell(cell).count.should == 1
		end
		it "detects live neighbor to the north-west" do
			subject.cell_grid[cell.y - 1][cell.x - 1].alive = true
			subject.live_neighbors_around_cell(cell).count.should == 1
		end

		it "should randomly populate the world" do
			subject.live_cells.count.should == 0
			subject.randomly_populate
			subject.live_cells.count.should_not == 0
		end

	end

	context "Cell" do

		subject { Cell.new }

		it "should create a new cell object" do
			subject.is_a?(Cell).should be_true
		end

		it "should respond to proper methods" do
			subject.should respond_to(:alive)
			subject.should respond_to(:x)
			subject.should respond_to(:y)
			subject.should respond_to(:alive?)
			subject.should respond_to(:die!)
		end

		it "should initialize properly" do
			subject.alive.should be_false
			subject.x.should == 0
			subject.y.should == 0
		end

	end

	context "Game" do
		subject { Game.new }

		it "should create a new game object" do
			subject.is_a?(Game).should be_true
		end

		it "should respond to proper methods" do
			subject.should respond_to(:world)
			subject.should respond_to(:seeds)
		end

		it "should initalize properly" do
			subject.world.is_a?(World).should be_true
			subject.seeds.is_a?(Array).should be_true
		end

		it "should plant seeds primarily" do
			game = Game.new(world, [[1,2], [0,2]])
			world.cell_grid[1][2].should be_alive
		end

	end

	context "Rules" do

		let!(:game) { Game.new }

		context "Rule #1: Any live cell with fewer than two live neighbours dies, as if caused by under-population." do

			it "should kill a live cell with one live neighbor neighbor" do
				game = Game.new(world, [[1, 0], [2, 0]])
				game.tick!
				world.cell_grid[1][0].should be_dead
				world.cell_grid[2][0].should be_dead
			end

		end

		context "Rule #2: Any live cell with two or three live neighbours lives on to the next generation." do

			it "should not kill a cell with two live neighbors" do
				game = Game.new(world, [[1, 0], [2, 0], [1, 1]])
				game.tick!
				world.cell_grid[1][0].should be_alive
				world.cell_grid[2][0].should be_alive
				world.cell_grid[1][1].should be_alive
			end

			it "should not kill a cell with three live neighbors" do
				game = Game.new(world, [[1, 0], [2, 0], [2, 1], [1,1]])
				game.tick!
				world.cell_grid[1][0].should be_alive
				world.cell_grid[2][0].should be_alive
				world.cell_grid[1][1].should be_alive
				world.cell_grid[2][1].should be_alive
			end
		end

		context "Rule #3: Any live cell with more than three live neighbours dies, as if by overcrowding." do

			it "should kill a cell with more than three live neighbors" do
				game = Game.new(world, [[1, 0], [2, 0], [1, 1], [2, 1], [0, 0]])
				game.tick!
				world.cell_grid[0][0].should be_alive
				world.cell_grid[1][0].should be_dead
				world.cell_grid[2][0].should be_alive
				world.cell_grid[1][1].should be_dead
				world.cell_grid[2][1].should be_alive
			end
		end

		context "Rule #4: Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction." do

			it "should bring a cell back to life with exactly three live neighbors" do
				game = Game.new(world, [[1, 0], [2, 0], [2, 1], [1,1]])
				world.cell_grid[1][0].alive = false
				world.cell_grid[1][0].should be_dead
				game.tick!
				world.cell_grid[1][0].should be_alive
				world.cell_grid[2][0].should be_alive
				world.cell_grid[2][1].should be_alive
			end

		end

	end
end