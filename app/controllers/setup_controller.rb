class SetupController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    game = Game.find_by( uuid: cookies[:game_id])
    comp_player = game.get_player(game.computer_game_player_id)
    game_player = game.get_player(game.human_game_player_id)

    if params[:lucky] == nil
      ship_configs = ShipType.all.map do |ship_type|
        {
          ship_type_id: ship_type.id,
          coords: []
        }
      end

      game_player.grid.cells.each do |cell|
        ship_type_id = params[cell.coord.to_sym]

        if ship_type_id != ''
          ship_config = ship_configs.find do |ship_config|
            ship_config.fetch(:ship_type_id) == ship_type_id.to_i
          end
          ship_config.fetch(:coords).push(cell.coord)
        end
      end
      
      unless game_player.create_ships(ship_configs)
        flash[:error] = "Incorrect ship layout, please place them again!"
        return redirect_to :action => "create"
      end
      
    else
      game_player.create_ships
    end
    comp_player.create_ships
    redirect_to :controller => 'game', :action => 'game'

  end

  def setup
    game = Game.create
    @ships = ShipType.all
    game_player = game.get_player(game.human_game_player_id)
    @grid = game_player.grid.as_2d
    cookies[:game_id] = {value: "#{game.uuid}", expiry: 1.year}
  end

end
