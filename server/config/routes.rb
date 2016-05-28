Rails.application.routes.draw do
  resources :videos do
    collection do
      post :upload
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
