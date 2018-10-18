class Ship < ApplicationRecord
  belongs_to :game_player
  belongs_to :ship_type
end
