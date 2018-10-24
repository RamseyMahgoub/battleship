require 'rails_helper'

RSpec.describe Grid, type: :model do
  let(:game) { Game.create }
  let(:game_player) { game.get_player(game.human_game_player_id) }

  it 'create will make a grid for the game player' do
    grid = Grid.create(game_player)
    expect(grid.game_player).to be(game_player)
  end

  it 'create makes cells in a grid of size 1' do
    grid = Grid.create(game_player, 1)
    expect(grid.cells.length).to be(1)
    expect(grid.cells.first.x).to eq(1)
    expect(grid.cells.first.y).to eq(1)
  end

  it 'create makes cells in a grid of size 3' do
    grid = Grid.create(game_player, 3)
    expect(grid.cells.length).to be(9)

    actual = grid.cells.map { |cell| cell.coord }
    expect(actual).to match_array(['A1', 'A2', 'A3', 'B1', 'B2', 'B3', 'C1', 'C2', 'C3'])
  end

  it 'size returns the size of the grid' do
    grid = Grid.create(game_player, 3)
    expect(grid.size).to be(3)
  end

  it 'creates a grid of 10x10 by default' do
    grid = Grid.create(game_player)
    expect(grid.cells.length).to be(100)
  end

  it 'as_2d returns a 2d array of cells' do
    grid = Grid.create(game_player, 2)

    actual = grid.as_2d
    expected = [['A1', 'A2'],['B1', 'B2']]

    expect(actual.length).to eq(2)
    expect(actual[0].length).to eq(2)
    expect(actual[1].length).to eq(2)

    actual.each_with_index do |actual_row, row_index|
      actual_row.each_with_index do |actual_cell, column_index|
        expect(actual_cell.coord).to eq(expected[row_index][column_index])
      end
    end
  end

  it 'as_2d takes a block which can mutate the cells in the 2d array' do
    grid = Grid.create(game_player, 2)

    actual = grid.as_2d do |cell|
      cell.coord
    end

    expected = [['A1', 'A2'],['B1', 'B2']]

    expect(actual.length).to eq(2)
    expect(actual[0].length).to eq(2)
    expect(actual[1].length).to eq(2)

    actual.each_with_index do |actual_row, row_index|
      actual_row.each_with_index do |actual_coord, column_index|
        expect(actual_coord).to eq(expected[row_index][column_index])
      end
    end
  end

  it 'find_cell_by_coord returns the grid cell for a coord string' do
    grid = Grid.create(game_player, 2)

    expect(grid.find_cell_by_coord('B1').coord).to eq('B1')
  end

  it 'has a default size const' do
    expect(Grid.default_size).to be(10)
  end
end
