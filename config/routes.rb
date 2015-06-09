Rails.application.routes.draw do
  devise_for :users
  resource :users, only: [] do
    member do
      get :edit_phone_number
      patch :update_phone_number
      get :call_verification_code
      get :verification_code
      post :verification
    end
  end
  root 'home#index'
end
