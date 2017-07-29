Rails.application.routes.draw do
  get 'wallets/index'

  post 'wallets/add_balance'

  get 'balances/index'

  get 'rateplans/index'

  get 'campaigns/index'

  get 'sessions/new'

  post 'sessions/login'
  get 'welcome/index'

  root 'sessions#new'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
