Rails.application.routes.draw do
  get "timers/index"
  get "timers/create"
  get "timers/complete"
  get "profiles/edit"
  get "profiles/update"
  get "profiles/show"
  get "home/index"
  devise_for :users
  # それぞれ標準装備のルーティングのため自動でGETとかPOSTに合わせてマッピング設定してくれる
  resources :profiles, only: [ :show, :edit, :update ]
  resources :timers, only: [ :index, :create ] do
    collection do
      post :complete # comleteはないから新たに設定
      post :save_progress  # 進捗保存用のエンドポイントを追加
    end
  end
  # 初期トップでindex.htmlにいく
  root to: "home#index"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
