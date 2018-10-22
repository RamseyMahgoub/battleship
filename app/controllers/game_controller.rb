class GameController < ApplicationController
  skip_before_action :verify_authenticity_token

  def game
  end
  
  def setup
    @game = Game.create
    @ships = ShipType.all
    @player_id = @game.human_game_player_id
    @game_player = @game.get_player(@player_id)
    @setup_hash = {
      "ships" => @ships,
      "grid" => @game_player.grid.as_2d,
      "game_player" => @game_player,
      "game" => @game,
      
    }
   # render json: @setup_hash

  @setup_hash
  end

  def create
    @params = params
    @ships = params["my_ships"]
    @set_ships = @ships.map do |key, value|
       { "name" => key, "coord" => value}
    end
    @game = Game.find(@params["game_id"])
    @human = @game.get_player(@game.human_game_player_id)
    @comp = @game.get_player(@game.computer_game_player_id)
    # @human_ships = @human.set_ships()
    render json: @set_ships
  end

  def finished
  end
  
end
