Rails.application.routes.draw do



  get 'holidays/feed' => 'holidays#feed', defaults: { format: 'json' }

  resources :conflicts, only: [:create] do
    collection do
      get 'feed', defaults: { format: 'json' }
    end
  end

  resources :schedules, only: [:index] do
    collection do
      get 'feed', defaults: { format: 'json' }
      delete 'clear'
      post :set_schedule
    end
  end

  get 'schedules/:employee_id' => 'schedules#index'
end
