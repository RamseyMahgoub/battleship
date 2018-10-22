class GameController < ApplicationController
  skip_before_action :verify_authenticity_token

  def game
    game = Game.find(params[:id])
    human_player = game.get_player(game.human_game_player_id)
    comp_player = game.get_player(game.computer_game_player_id)
    @human_ships = human_player.ships.all.map do |ship|
      {
        name: ship.ship_type.name,
        cells: ship.cells.map{ |cell| cell.state(true) }
      }
    end
    @human_grid = human_player.grid.as_2d do |cell|
      {state: cell.state(true)}
    end
    @comp_grid = comp_player.grid.as_2d do |cell|
      {
        state: cell.state,
        url: "/game/#{game.id}/fire/#{cell.coord}" 
      }
    end
    @result = game.result

  end
  
<<<<<<< HEAD
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
=======
  def fire
    game = Game.find(params[:id])
    game.target(params[:coord])
    redirect_to :controller => 'game_controller', :action => 'game' 
>>>>>>> 060cd99f6b9803110a40a0f29902cdec4b6f7259
  end

  def change_turn
    game = Game.find(params[:id])
    game.change_turn
    game.target
    game.change_turn
    redirect_to :controller => 'game_controller', :action => 'game'
  end

  def finished
    game = Game.find(params[:id])
    human_player = game.get_player(game.human_game_player_id)
    comp_player = game.get_player(game.computer_game_player_id)
    @human_ships = human_player.ships.all.map do |ship|
      {
        name: ship.ship_type.name,
        cells: ship.cells.map{ |cell| cell.state(true) }
      }
    end
    @human_grid = human_player.grid.as_2d do |cell|
      {state: cell.state(true)}
    end
    @comp_grid = comp_player.grid.as_2d do |cell|
      {
        state: cell.state(true)
      }
    end
    @comp_ships = comp_player.ships.all.map do |ship|
      {
        name: ship.ship_type.name,
        cells: ship.cells.map{ |cell| cell.state(true) }
      }
    end
    @result = game.result
  end
  
end
