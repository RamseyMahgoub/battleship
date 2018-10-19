class GameController < ApplicationController

  def game
  end
  
  def setup
    @ships = ShipType.all 
    @ships
    #render json: @ships
  end

  def finished
  end
  
end
