class GameController < ApplicationController

  def game
  end
  
  def setup
   @ships = ShipType.all 
   @ships
  end

  def finished
  end
  
end
