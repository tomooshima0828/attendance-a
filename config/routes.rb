Rails.application.routes.draw do
  
  root 'static_pages#top'
  get '/signup', to: 'users#new'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :branch_offices

  resources :working_employees, only: :index
  
  resources :users do
    # memberは:idあり
    member do
      # GET	/users/:id/edit_basic_info
      get 'edit_basic_info'
      # PATCH	/users/:id/update_basic_info
      patch 'update_basic_info'
      # GET /users/:id/attendances/edit_one_month ユーザーに紐付いた勤怠情報の集合をeditする
      get 'attendances/edit_one_month'
      # PATCH /users/:id/attendances/update_one_month ユーザーに紐付いた勤怠情報の集合をupdateする
      patch 'attendances/update_one_month'
    end
    # collectionは:id無し
    # CSVインポート POST /users/import
    collection { post :import }

    # GET /users/:user_id/edit_overtime_request
    get 'edit_overtime_response' # 〇〇からの残業申請 表示
    # PATCH /users/:user_id/update_overtime_request
    patch 'update_overtime_response' # 〇〇からの残業申請 更新

    # GET /users/:user_id/edit_working_hours_response
    get 'edit_working_hours_response' # 〇〇からの勤怠変更申請
    # PATCH /users/:user_id/update_working_hours_response
    patch 'update_working_hours_response' # 〇〇からの勤怠変更申請
    
    # PATCH /users/:user_id/attendances/:id 個別のattendanceの属性(出勤、退勤)をupdateする
    resources :attendances, only: :update do
      member do
        # GET /users/:user_id/attendances/:id/edit_overtime_info
        get 'edit_overtime_request' # 残業申請
        # PATCH /users/:user_id/attendances/:id/update_overtime_info
        patch 'update_overtime_request' # 残業申請 ①:user_id②:idをform_withでupdate_overtime_infoに渡す
        
      end
    end
    
  end

end
