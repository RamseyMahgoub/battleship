require 'rails_helper'

RSpec.describe SetupController, type: :controller do

    it "should return a status code of 200 for a successful GET request." do
      get :setup
      expect(response.status).to eq(200)
    end
    
    it "returns the required instance variable grid needed to setup the game." do
      get :setup
      expect(assigns(:grid).length).to eql(10)
    end

    it "returns the required instance variable grid needed to setup the game." do
      get :setup
      expect(assigns(:game_id).class).to be(Fixnum)
    end

    it "expects the default value of a grid cells targeted property to be false.." do
      get :setup 
      expect(assigns(:grid)[0][0].targeted).to be(false)
    end
end


RSpec.describe SetupController, type: :controller do
  response_obj = {
      "utf8"=>"✓",
      "authenticity_token"=>"d/1VtxbxlsvXCmg0laJ2MTVZiIfE5z8aujUqlkgxHx69YgBILrOyCjZcqsRB0u7g3VBbMFuhJPfBNk5mXOm6og==",
      "commit"=>"Confirm positions",
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
      "game_id"=> "30"  
  }
    it "should return a status code of 302 for a successful GET request." do
      get :setup
      id = assigns(:game_id)
      response_obj["game_id"] = id
      post :create, params: response_obj
      expect(response.status).to eq(302)
    end

    it "should return a status code of 302 for a successful GET request." do
      get :setup
      id = assigns(:game_id)
      response_obj["game_id"] = id
      post :create, params: response_obj
      expect(response).to redirect_to "/game/#{id}"
    end
end
