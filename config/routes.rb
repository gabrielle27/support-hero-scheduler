Rails.application.routes.draw do

  mount CurrentUser::Engine => '/current_user'

  root 'schedules#index'

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

  resources :swap_requests, only: [:create, :update], defaults: { format: 'json' }

  get 'employee/dates' => 'employees#scheduled_dates'
  get 'schedules/:employee_id' => 'schedules#index'
  get 'signed_in' => 'application#signed_in'

end
