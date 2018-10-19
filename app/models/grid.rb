class Grid < ApplicationRecord
  belongs_to :game_player
  has_many :cells

  def create_cells(size = 2)
    (1..size).each do |x|
      (1..size).each do |y|
        cells.create(:x => x, :y => y)
      end
    end
  end

  def size
    cells.max_by { |cell| cell.x }.x
  end

  def as_2d
    cells.each_slice(size).to_a
  end
end
