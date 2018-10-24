class Grid < ApplicationRecord
  belongs_to :game_player
  has_many :cells

  def self.create(game_player, size = 10)
    grid = super(game_player: game_player)
    grid.create_cells(size)
    grid
  end

  def size
    cells.max_by { |cell| cell.x }.x
  end

  def as_2d(&block)
    cells.map(&block).each_slice(size).to_a
  end

  def create_cells(size)
    (1..size).each do |x|
      (1..size).each do |y|
        cells.create(x: x, y: y)
      end
    end
  end

  def find_cell_by_coord(coord)
    cells.find { |cell| cell.coord == coord }
  end
end
