class GamePlayer < ApplicationRecord
  belongs_to :game
  has_one :grid
end
