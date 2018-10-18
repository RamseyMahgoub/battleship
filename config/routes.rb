Rails.application.routes.draw do
  root to: "home#index"
  get "/game", to: "game#game"
  get "/game/setup", to: "game#setup"
  get "/game/finished", to: "game#finished"
end
