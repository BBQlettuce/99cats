Rails.application.routes.draw do
  resources :cats
  resources :cat_rental_requests do
    member do
      patch 'deny'
      patch 'approve'
    end
  end

end
