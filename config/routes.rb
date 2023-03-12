# frozen_string_literal: true

Rails.application.routes.draw do
  root 'static_pages#top'
  get '/signup', to: 'users#new'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :branch_offices

  resources :users do
    # collectionは:id無し
    # CSVインポート POST /users/import
    collection { post :import }
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

      # PATCH /users/:id/attendances/update_monthly_request
      patch 'attendances/update_monthly_request' # 1ヶ月申請 上長を選択して申請

      # GET /users/:id/edit_monthly_approval
      get 'attendances/edit_monthly_approval' # 上長 1ヶ月モーダル 表示
      # GET /users/:id/update_monthly_approval
      patch 'attendances/update_monthly_approval' # 上長 1ヶ月モーダル 更新
      # GET /users/:id/attendance_confirmation
      get 'attendance_confirmation'
      # GET /users/:id/attendance_log
      get 'attendance_log' # 勤怠ログ(承認済み)

      get 'edit_basic_info2'
    end

    collection do
      get 'working_employees'
    end

    # GET /users/:user_id/edit_overtime_approval
    get 'edit_overtime_approval' # 上長 残業モーダル
    # PATCH /users/:user_id/update_overtime_approval
    patch 'update_overtime_approval' # 上長 残業モーダル 更新

    # GET /users/:user_id/edit_working_hours_approval
    get 'edit_working_hours_approval' # 上長 勤怠変更モーダル
    # PATCH /users/:user_id/update_working_hours_approval
    patch 'update_working_hours_approval' # 上長勤怠変更モーダル 更新

    # PATCH /users/:user_id/attendances/:id 個別のattendanceの属性(出勤、退勤)をupdateする
    resources :attendances, only: :update do
      member do
        # GET /users/:user_id/attendances/:id/edit_overtime_request
        get 'edit_overtime_request' # 残業申請モーダル
        # PATCH /users/:user_id/attendances/:id/update_overtime_request
        patch 'update_overtime_request' # 残業申請モーダル 更新
      end
    end
  end
end
