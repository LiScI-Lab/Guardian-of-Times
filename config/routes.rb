Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'user/sessions', omniauth_callbacks: 'user/omniauth_callbacks' }
  root 'welcome#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :users, only: [:show, :edit, :update] do
    member do
      get :dashboard
    end
  end

  resources :teams do
    collection do
      scope :role do
        get :owner
      end
      scope :status do
        get :invited
      end
    end

    member do
      patch :join
      get :dashboard
    end

    scope module: :team do
      #resources :sub_teams, only: [:index, :new, :create]
      resources :members, only: [:index, :show, :new, :edit, :update, :destroy] do
        collection do
          post :invite
        end
        member do
          get :dashboard
          patch :restore
        end

        scope module: :member do
          resources :progresses, only: [:index, :create, :edit, :update, :new, :destroy] do
            collection do
              post :start
              get :import
              post :upload
            end

            member do
              patch :stop
              patch :restore
            end
          end

        end
      end
      resources :progresses, only: [:index, :show]
      resources :export, only: [:index, :create]
    end
  end
end
