class AttendancesController < ApplicationController
  before_action :set_user, only: [:edit_one_month, :update_one_month, :update_monthly_request]
  before_action :logged_in_user, only: [:update, :edit_one_month]
  before_action :admin_or_correct_user, only: [:update, :edit_one_month, :update_one_month]
  before_action :set_one_month, only: :edit_one_month

  UPDATE_ERROR_MSG = "勤怠登録に失敗しました。やり直してください。"

  def update
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:id])
    # 出勤時間が未登録であることを判定します。
    if @attendance.started_at.nil?
      if @attendance.update_attributes(started_at: Time.current.change(sec: 0))
        flash[:info] = "おはようございます！"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    elsif @attendance.finished_at.nil?
      if @attendance.update_attributes(finished_at: Time.current.change(sec: 0))
        flash[:info] = "お疲れ様でした。"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    end
    redirect_to @user
  end

  def edit_one_month
    
  end

  def update_one_month
    ActiveRecord::Base.transaction do # トランザクションを開始します。
      attendances_params.each do |id, item|
        attendance = Attendance.find(id)
        attendance.update_attributes!(item)
      end
    end
    
    flash[:success] = "1ヶ月分の勤怠情報を更新しました。"
    redirect_to user_url(date: params[:date])
  rescue ActiveRecord::RecordInvalid # トランザクションによるエラーの分岐です。
    flash[:danger] = "無効な入力データがあった為、更新をキャンセルしました。"
    redirect_to attendances_edit_one_month_user_url(date: params[:date])

  end

  
  def edit_overtime_request # 残業申請 表示
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:id])
    
  end

  def update_overtime_request # 残業申請 提出
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:id])
    
    if overtime_request_params[:next_day_overtime] == "false"
      if overtime_request_params[:estimated_overtime_hours].to_i < @user.designated_work_end_time.hour
        flash[:danger] = "残業時間が翌日になる場合は「翌日」をチェックしてください。"
        redirect_to @user and return
      end
    end
    
    if @attendance.update_attributes(overtime_request_params)
      
      flash[:success] = "#{@user.name}の残業申請が完了しました。"
    end
    redirect_to @user and return
  end

  # 画面右下の1ヶ月申請ボタンを押したときのアクション
  def update_monthly_request
    
    # @userはset_userでセットしている
    @attendance = @user.attendances.where(worked_on: params[:attendance][:date_monthly_request])
    
    # 上長を選択したら申請が可能
    if monthly_request_params[:selector_monthly_request].present?
      @attendance.update(monthly_request_params)
      flash[:success] = "#{@user.name}の1ヶ月分の勤怠情報を申請しました。"
    else
      flash[:danger] = "上長を選択して下さい。" 
    end
    redirect_to @user
  end

  def edit_monthly_approval
    # 上長をパラメーターから取得する
    @user = User.find(params[:id])
    @users = User.joins(:attendances).group("users.id").where(attendances: { selector_monthly_request: @user.employee_number, status_monthly: "申請中" } )
    # 上長のIDと同じ番号のattendance.selector_monthly_requestを取得する
    @attendances = Attendance.where(selector_monthly_request: @user.employee_number, status_monthly: '申請中')
    @attendances.each do |attendance|
      attendance.change_monthly = nil
    end
  end

  def update_monthly_approval
    
    ActiveRecord::Base.transaction do
      monthly_approval_params.each do |id, item|

        if item[:change_monthly] == "true"

          attendance = Attendance.find(id)
          attendance.update_attributes!(item)
        end
      end
      flash[:success] = "1ヶ月分の勤怠情報を更新しました。"
      redirect_to user_url(params[:id]) and return
    end
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = "無効なデータがあったため、更新をキャンセルしました"
    redirect_to user_url(params[:id]) and return
  end

  


  private

  

  # ユーザー1名で単数の勤怠を更新する場合はこの書き方で
  def overtime_request_params
    params.require(:attendance).permit(:estimated_overtime_hours, :next_day_overtime, :business_process_content, :selector_overtime_request, :status_overtime)
  end

  def monthly_request_params
    params.require(:attendance).permit(:date_monthly_request, :status_monthly, :selector_monthly_request)
  end

  def monthly_approval_params
    params.require(:user).permit(attendances: [:status_monthly, :change_monthly])[:attendances]
  end

    # beforeフィルター

    # 管理権限者、または現在ログインしているユーザーを許可します。
    def admin_or_correct_user
      @user = User.find(params[:user_id]) if @user.blank?
      unless current_user?(@user) || current_user.admin?
        flash[:danger] = "編集権限がありません。"
        redirect_to(root_url)
      end  
    end
end