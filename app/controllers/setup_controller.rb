class SetupController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    game = Game.find(params[:game_id])
    comp_player = game.get_player(game.computer_game_player_id)
    game_player = game.get_player(game.human_game_player_id)
    ship_configs = ShipType.all.map do |ship_type|
      coords = param[ship_type.id.to_s.to_sym]
      {
        ship_type_id: ship_type.id,
        coords: coords
      }
    end
    game_player.create_ships(ship_configs)
    comp_player.create_ships
    redirect_to :controller => 'game_controller', :action => 'game'
    
  end

  def setup
    game = Game.create
    @ships = ShipType.all
    game_player = game.get_player(game.human_game_player_id)
    @grid = game_player.grid.as_2d


  end

end
