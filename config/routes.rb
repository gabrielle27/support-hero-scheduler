Rails.application.routes.draw do





  resources :schedules, only: [:index] do
    collection do
      get 'feed', defaults: { format: 'json' }
    end
  end

  get 'schedules/:employee_id' => 'schedules#index'
end
