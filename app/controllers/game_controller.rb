class GameController < ApplicationController
  skip_before_action :verify_authenticity_token

  def game
    game = Game.find_by( uuid: cookies[:game_id])
    if !game || !game.setup?
      return redirect_to controller: 'home', action: 'index'
    end
    human_player = game.get_player(game.human_game_player_id)
    comp_player = game.get_player(game.computer_game_player_id)
    @human_ships = human_player.ships.all.map do |ship|
      {
        name: ship.ship_type.name,
        cells: ship.cells.map{ |cell| cell.state(true) },
        sunk: ship.sunk?
      }
    end
    @comp_ships = comp_player.ships.all.map do |ship|
      {
        name: ship.ship_type.name,
        cells: ship.cells.map { |cell| cell.state(true) },
        sunk: ship.sunk?
      }
    end
    @human_grid = human_player.grid.as_2d do |cell|
      {
        state: cell.state(true),
        coord: cell.coord,
        latest_turn: human_player.previous_turn_cell == cell,
        piece: (cell.ship_cell.piece if cell.state(true) == :ship || cell.state(true) == :sunk || cell.state(true) == :hit)
      }
    end
    @comp_grid = comp_player.grid.as_2d do |cell|
      {
        state: cell.state,
        coord: cell.coord,
        url: "/game/fire/#{cell.coord}",
        latest_turn: comp_player.previous_turn_cell == cell,
        piece: (cell.ship_cell.piece if cell.state == :sunk)

      }
    end
    @result = game.result
    @can_change_turn = game.can_change_turn?
  end

  def fire
    game = Game.find_by( uuid: cookies[:game_id])
    flash[:error] = "Cannons disabled, the battle is over!!." if game.result  && !game.target(params[:coord]) 
    flash[:error] = "Already Fired!! Please click Next turn." if !game.result  && !game.target(params[:coord]) 
    redirect_to :action => 'game'
  end

  def change_turn
    game = Game.find_by( uuid: cookies[:game_id])
    if !game.change_turn
      flash[:error] = "It's your turn to fire...." 
      return redirect_to :action => 'game'
    end
    game.target
    game.change_turn
    redirect_to :action => 'game'
  end

  def finished
    game = Game.find_by( uuid: cookies[:game_id])
    human_player = game.get_player(game.human_game_player_id)
    comp_player = game.get_player(game.computer_game_player_id)
    @human_ships = human_player.ships.all.map do |ship|
      {
        name: ship.ship_type.name,
        cells: ship.cells.map{ |cell| cell.state(true) },
        sunk: ship.sunk?
      }
    end
    @human_grid = human_player.grid.as_2d do |cell|
      {
        state: cell.state(true),
        coord: cell.coord,
      }
    end
    @comp_grid = comp_player.grid.as_2d do |cell|
      {
        state: cell.state(true),
        coord: cell.coord,
      }
    end
    @comp_ships = comp_player.ships.all.map do |ship|
      {
        name: ship.ship_type.name,
        cells: ship.cells.map{ |cell| cell.state(true) },
        sunk: ship.sunk?
      }
    end
    @result = game.result
  end

end
