require 'rails_helper'

RSpec.describe GameController, type: :controller do
  response_obj = {
    "utf8"=>"✓",
    "authenticity_token"=>"d/1VtxbxlsvXCmg0laJ2MTVZiIfE5z8aujUqlkgxHx69YgBILrOyCjZcqsRB0u7g3VBbMFuhJPfBNk5mXOm6og==",
    "commit"=>"Confirm positions",
    :coord => "B2",
    "A1"=>"1",
    "A2"=>"",
    "A3"=>"",
    "A4"=>"",
    "A5"=>"",
    "A6"=>"",
    "A7"=>"3",
    "A8"=>"2",
    "A9"=>"",
    "A10"=>"",
    "B1"=>"1",
    "B2"=>"",
    "B3"=>"",
    "B4"=>"",
    "B5"=>"",
    "B6"=>"",
    "B7"=>"3",
    "B8"=>"2",
    "B9"=>"",
    "B10"=>"",
    "C1"=>"",
    "C2"=>"",
    "C3"=>"",
    "C4"=>"",
    "C5"=>"",
    "C6"=>"",
    "C7"=>"3",
    "C8"=>"2",
    "C9"=>"",
    "C10"=>"",
    "D1"=>"",
    "D2"=>"",
    "D3"=>"",
    "D4"=>"",
    "D5"=>"",
    "D6"=>"",
    "D7"=>"",
    "D8"=>"",
    "D9"=>"",
    "D10"=>"",
    "E1"=>"",
    "E2"=>"",
    "E3"=>"4",
    "E4"=>"4",
    "E5"=>"4",
    "E6"=>"4",
    "E7"=>"",
    "E8"=>"",
    "E9"=>"",
    "E10"=>"",
    "F1"=>"",
    "F2"=>"",
    "F3"=>"5",
    "F4"=>"5",
    "F5"=>"5",
    "F6"=>"5",
    "F7"=>"5",
    "F8"=>"",
    "F9"=>"",
    "F10"=>"",
    "G1"=>"",
    "G2"=>"",
    "G3"=>"",
    "G4"=>"",
    "G5"=>"",
    "G6"=>"",
    "G7"=>"",
    "G8"=>"",
    "G9"=>"",
    "G10"=>"",
    "H1"=>"",
    "H2"=>"",
    "H3"=>"",
    "H4"=>"",
    "H5"=>"",
    "H6"=>"",
    "H7"=>"",
    "H8"=>"",
    "H9"=>"",
    "H10"=>"",
    "I1"=>"",
    "I2"=>"",
    "I3"=>"",
    "I4"=>"",
    "I5"=>"",
    "I6"=>"",
    "I7"=>"",
    "I8"=>"",
    "I9"=>"",
    "I10"=>"",
    "J1"=>"",
    "J2"=>"",
    "J3"=>"",
    "J4"=>"",
    "J5"=>"",
    "J6"=>"",
    "J7"=>"",
    "J8"=>"",
    "J9"=>"",
    "J10"=>"",
    "id"=> 30  
}
    it "should redirect to home page if no game has been setup." do
      game = Game.create
      get :game
      expect(response).to redirect_to '/'
    end

    it "should return an array for instance variable human_grid of length 10." do
      game = Game.create
      id = game.id
      response_obj[:id] = id
      post :game, params: response_obj
      expect(assigns(:human_grid)).to be_an(Array)
      expect(assigns(:human_grid).length).to eql(10)
    end

    it "should return an array for instance variable comp_grid of length 10." do
      game = Game.create
      id = game.id
      response_obj[:id] = id
      post :game, params: response_obj
      expect(assigns(:comp_grid)).to be_an(Array)
      expect(assigns(:comp_grid).length).to eql(10)
    end

    it "should return an array for instance variable game_id." do
      game = Game.create
      id = game.id
      response_obj[:id] = id
      post :game, params: response_obj
      expect(assigns(:game_id)).to eql(id)
    end

    it "should return an array for instance variable human_ships." do
      game = Game.create
      game.game_players[1].create_ships
      id = game.id
      response_obj[:id] = id
      post :game, params: response_obj
      expect(assigns(:human_ships).size).to eql(5)
    end


    describe GameController, type: :controller do

      it 'should redirect to game controller.' do
        game = Game.create
        cookies[:game_id] = "f-0TFdKknRqBy9xNXqf_oQ"
        post :fire
        expect(response).to redirect_to "/game"    
      end
      
    end
end