require 'battleships'
RSpec.describe 'Battleships' do
  it 'should return an array of one ship.' do
    battleship = Battleship.new
    expect(battleship.my_ships).to eq([["a1"]])
  end

  it 'should return an array of hits on my_grid.' do
    battleship = Battleship.new
    expect(battleship.my_grid).to eq([])
  end

  it 'should return an array of hits on their_grid.' do
    battleship = Battleship.new
    expect(battleship.their_grid).to eq([])
  end
  
  it 'should fire at a grid cell and return miss.' do
    battleship = Battleship.new
    expect(battleship.fire("c1")).to eq(false)
  end

  it 'should fire at a grid cell and return miss.' do
    battleship = Battleship.new
    expect(battleship.fire("c2")).to eq(false)
  end

  it 'should fire at a grid cell and return hit.' do
    battleship = Battleship.new
    expect(battleship.fire("b1")).to eq(true)
  end

  it 'should return their grid their_grid with shot history.' do
    battleship = Battleship.new
    battleship.fire("b1")
    expect(battleship.their_grid[0].hit).to eq(true)
    expect(battleship.their_grid[0].coord).to eq("b1")
  end

  it 'battleships next_turn should make the computer fire and miss.' do
    battleship = Battleship.new
    battleship.next_turn
    expect(battleship.my_grid[0].hit).to eq(false)
    expect(battleship.my_grid[0].coord).to eq("a2")
  end
end