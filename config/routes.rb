Rails.application.routes.draw do
  devise_for :users
  root 'welcome#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :users, only: [:show, :edit, :update]
  resources :projects do
    collection do
      scope :role do
        get :invited
        get :owner
      end
    end

    scope module: :project do
      resources :members
      resources :progresses do
        member do
          patch :stop
        end
      end
      resources :export, only: [:index, :create]
    end
  end
end
