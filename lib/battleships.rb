class Battleship

  def initialize(grid_size, my_ships)
    @my_turn = true
    @my_ships = my_ships.map{ |ship| ship.map{ |coord| Cell.new(coord)}}
    @opponent_ships = [[Cell.new("b1")]]
    @opponent_grid = []
    @my_grid = []
    @grid_size = grid_size

  end

  def my_ships
    @my_ships
  end

  def my_grid
    @my_grid
  end

  def opponent_grid
    @opponent_grid
  end

  def fire(coord)
    turn = Turn.new(coord, @opponent_grid, @my_grid, @my_turn, @grid_size, @opponent_ships, @my_ships)
    sunken_ship = false
    hit = nil
    result = false

    if !turn.error
      if @my_turn
        ships = @opponent_ships
        grid = @opponent_grid
      else
        ships = @my_ships
        grid = @my_grid
      end

      hit = ships.any? do |ship|
        ship_hit = ship.any? do |cell|
          cell_hit = cell.coord == coord

          if cell_hit
            cell.hit = true
          end

          cell_hit
        end

        if ship_hit
          ship_shunk = ship.all? { |cell| cell.hit == true }
        end

        if ship_shunk
          sunken_ship = ship
        end

        ship_hit
      end
      grid << Cell.new(coord,hit)


      result = ships.all? do |ship|
        ship.all? do |cell|
          cell.hit
        end
      end
    end

    turn.hit = hit
    turn.sunk = sunken_ship
    turn.result = result
    turn
  end

  def next_turn
    @my_turn = !@my_turn
  end
end

class Turn
  attr_accessor :hit, :sunk, :result

  def initialize(coord, opponent_grid, my_grid, my_turn, grid_size, opponent_ships, my_ships)
    if opponent_grid.size > my_grid.size && my_turn
      @error = 'Not your turn'
    else
      xy = coord_to_x_y(coord)

      if (xy[:x] > grid_size || xy[:y] > grid_size)
        @error = 'Out of grid'
      end
    end
  end

  def coord_to_x_y(coord)
    start = 'a'.ord - 1

    {
      x: coord.chars[1].to_i,
      y: coord.chars[0].ord - start,
    }
  end

  def error
    @error
  end
end

class Cell
  attr_accessor :hit

  def initialize(coord, hit = false)
    @coord = coord
    @hit = hit
  end

  def coord
    @coord
  end
end

