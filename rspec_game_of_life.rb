require 'rspec'
require_relative 'game_of_life.rb'

describe 'Game of life' do

	let!(:world) { World.new }

	context 'World' do
		subject { World.new }

		it 'should create a new world object' do
			subject.is_a?(World).should be_true
		end

		it "should respond to proper methods" do
			subject.should respond_to(:rows)
			subject.should respond_to(:cols)
			subject.should respond_to(:cell_grid)
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
			end
		end

	end
end