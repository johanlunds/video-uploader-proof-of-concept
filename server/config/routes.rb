Rails.application.routes.draw do
  resources :videos
  resources :video_uploads do
    collection do
      post :sns_notifications
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
