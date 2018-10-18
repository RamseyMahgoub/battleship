class Grid < ApplicationRecord
  belongs_to :game_player
  has_many :cells
end
