Rails.application.routes.draw do
  get "" => "teste#info", as: :home
  get "info" => "teste#info", as: :info
  get "car" => "teste#car", as: :car
  get "notebooks" => "teste#notebooks", as: :notebooks
  get "smartphones" => "teste#smartphones", as: :smartphones
end
