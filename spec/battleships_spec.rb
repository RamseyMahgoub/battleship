require 'battleships'
RSpec.describe 'Battleships' do
  let (:battleship) { Battleship.new(3) }

  it 'should return an array of one ship.' do
    expect(battleship.my_ships[0][0].coord).to eq("a1")
  end

  it 'should return an array of hits on my_grid.' do
    expect(battleship.my_grid).to eq([])
  end

  it 'should return an array of hits on component_grid.' do
    expect(battleship.component_grid).to eq([])
  end

  it 'should fire at a grid cell and return miss.' do
    expect(battleship.fire("c1").hit).to eq(false)
  end

  it 'should fire at a grid cell and return miss.' do
    expect(battleship.fire("c2").hit).to eq(false)
  end

  it 'should fire at a grid cell and return hit.' do
    expect(battleship.fire("b1").hit).to eq(true)
  end

  it 'should return their grid component_grid with shot history.' do
    battleship.fire("b1")
    expect(battleship.component_grid[0].hit).to eq(true)
    expect(battleship.component_grid[0].coord).to eq("b1")
  end

  it 'battleships next_turn should make the computer fire and miss.' do
    battleship.next_turn
    battleship.fire("a2")
    expect(battleship.my_grid[0].hit).to eq(false)
    expect(battleship.my_grid[0].coord).to eq("a2")
  end

  it 'should only allow 1 fire per a turn.' do
    battleship.fire("a1")
    battleship.fire("b1")
    expect(battleship.component_grid.size).to be(1)
  end

  it 'should return "not your turn" if its not your turn.' do
    battleship.fire("a1")
    expect(battleship.fire("b1").error).to eq('Not your turn')
  end

  it 'should only allow shots within the grid vertically' do
    expect(battleship.fire("d3").error).to eq('Out of grid')
  end

  it 'should only allow shots within the grid horizontally' do
    expect(battleship.fire("c4").error).to eq('Out of grid')
  end

  it 'should return coords of sunked ship once sunk' do
    expect(battleship.fire("b1").sunk[0].coord).to eq('b1')
  end

  it 'should return the result of false when game not finished' do
    expect(battleship.fire("c1").result).to eq(false)
  end

  it 'should return the result of true when game has finished' do
    expect(battleship.fire("b1").result).to eq(true)
  end
end
