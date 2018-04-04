Rails.application.routes.draw do
  devise_for :users
  root 'welcome#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :users, only: [:show, :edit, :update]
  resources :projects do
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

    scope module: :project do
      resources :members, only: [:index, :show, :new] do
        collection do
          post :invite
        end
        member do
          get :dashboard
        end

        scope module: :member do
          resources :progresses, only: [:index, :create, :edit, :update,:new] do
            member do
              patch :update
              patch :stop
            end
          end
        end
      end
      resources :progresses, only: [:index, :show]
      resources :export, only: [:index, :create]
    end
  end
end
