class SetupController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    @game = Game.find(params["game_id"])
    @ships = params["my_ships"]
    @human = @game.get_player(@game.human_game_player_id)
    @comp = @game.get_player(@game.computer_game_player_id)
    ships_array = []
    @ships.each do |key, value|
      ship_id = ShipType.find_by name: key
      ship_hash = {
        ship_type_id: ship_id.id,
        coords: value
       }
       ships_array.push(ship_hash)
    end
    
    # @human_ships = @human.set_ships()
    render json: @human.create_ships(ships_array)
  end

  def setup
    @game = Game.create
    @ships = ShipType.all
    @game_player = @game.get_player(@game.human_game_player_id)
    @setup_hash = {
      "ships" => @ships,
      "grid" => @game_player.grid.as_2d,
      "game_player" => @game_player,
      "game" => @game
    }
    @setup_hash
  end

end
