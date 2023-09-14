Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  get '/merchants/:id/dashboard', to: 'merchants#show'

  get "/admin", to: "admin#index"
  get "/admin/merchants", to: "admin_merchants#index"
  get "/admin/invoices", to: "admin_invoices#index"
  get "admin/invoices/:id", to: "admin_invoices#show"
  
end
