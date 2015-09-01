Rails.application.routes.draw do





  resources :schedules, only: [:index] do
  end

end
