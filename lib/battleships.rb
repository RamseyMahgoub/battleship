class Battleship

  def initialize
    @their_ships = [["b1"]]
    @their_grid = []
    @my_grid = []
    @my_ships = [["a1"]]
  end

  def my_ships
    @my_ships
  end

  def my_grid
    @my_grid
  end

  def their_grid
    @their_grid
  end

  def fire(coord)
    hit = @their_ships.any? do |ship|
      ship.include?(coord)
    end
    @their_grid << Cell.new(coord,hit)
    hit
  end

  def their_fire(coord)
    hit = @my_ships.any? do |ship|
      ship.include?(coord)
    end
    @my_grid << Cell.new(coord,hit)
    hit
  end

  def next_turn

  end

end

class Cell
  def initialize(coord, hit)
    @coord = coord
    @hit = hit
  end

  def hit
    @hit
  end

  def coord
    @coord
  end
end

