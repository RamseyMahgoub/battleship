Rails.application.routes.draw do
  root to: "home#index"
  #get route to setup new game
  get "/setup", to: "setup#setup"

  #post for game setup
  post "/setup", to: "setup#create"

  #get route for game play
  get "/game/:id", to: "game#game"

  #get for game play
  #get "/game/:id", to: "game#game"

  #put to fire and switch user
  post "/game/:id/fire/:coord", to: "game#fire"

  post "game/:id/change_turn", to: "game#change_turn"

  #get route for end of game
  get "/game/:id/finished", to: "game#finished"

end
