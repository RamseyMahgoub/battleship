class GameController < ApplicationController
  skip_before_action :verify_authenticity_token

  def game
    player = GamePlayer.find(params[:id])
    grid = Grid.create(player)
    render json: grid
  end
  
  def finished
  end
  
end
