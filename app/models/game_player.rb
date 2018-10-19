class GamePlayer < ApplicationRecord
  belongs_to :game
  has_one :grid

  def self.create_human_player(game_id = nil)
    setup = {
      :active_turn => true,
      :human_player => true,
    }

    setup[:game_id] = game_id if (game_id)

    GamePlayer.create(setup)
  end

  def self.create_computer_player(game_id = nil)
    setup = {
      :active_turn => false,
      :human_player => false,
    }

    setup[:game_id] = game_id if (game_id)

    GamePlayer.create(setup)
  end
end
