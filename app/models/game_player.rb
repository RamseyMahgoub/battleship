class GamePlayer < ApplicationRecord
  belongs_to :game
  has_one :grid

  def self.create_human_player(game_id = nil)
    setup = {
      :active_turn => true,
      :human_player => true,
    }

    setup[:game_id] = game_id if (game_id)

    game_player = GamePlayer.create(setup)
    game_player.create_grid
    game_player
  end

  def self.create_computer_player(game_id = nil)
    setup = {
      :active_turn => false,
      :human_player => false,
    }

    setup[:game_id] = game_id if (game_id)

    game_player = GamePlayer.create(setup)
    game_player.create_grid
    game_player
  end

  def create_grid
    grid = Grid.create(:game_player => self)
    grid.create_cells
  end
end
