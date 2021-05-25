class UsersController < ApplicationController
  before_action :set_user, only: [:show, :attendance_confirmation, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :logged_in_user, only: [:index, :show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:index, :destroy, :edit_basic_info, :update_basic_info]
  before_action :non_admin_user, only: :show
  before_action :set_one_month, only: [:show, :attendance_confirmation]

  def index
    @users = User.paginate(page: params[:page])
  end

  def import
    if params[:csv_file].blank?
      flash[:danger] = '読み込むCSVを選択してください'
    else
      num = User.import(params[:csv_file])
      flash[:success] = "#{ num.to_s }件のデータ情報を追加/更新しました"
    end
    redirect_to users_path
  end

  def show
    # 1ヶ月の出勤回数の合計
    @worked_sum = @attendances.where.not(started_at: nil).count

    # 上長　申請された数をカウントして赤字で表示する
    # 上長　自身宛ての申請があり、かつステータスが申請中のときに、その数をカウントする
    if @user.superior?
      @count_monthly_request = Attendance.where(selector_monthly_request: @user.id, status_monthly: "申請中").count
      @count_working_hours_request = Attendance.where(selector_working_hours_request: @user.id, status_working_hours: "申請中").count
      @count_overtime_request = Attendance.where(selector_overtime_request: @user.id, status_overtime: "申請中").count
    end

    # 月初日を取得。
    # 申請者が1ヶ月申請を押したときに月初日に「申請中」が入る
    # 上長が「なし」「申請中」「否認」「承認」のどれかを選択することでstatusが変更される
    @first_day_monthly_request = @user.attendances.find_by(worked_on: @first_day)
       
    if @first_day_monthly_request.status_monthly == "申請中"
      if @first_day_monthly_request.selector_monthly_request == 2
        @status_updated = "上長1に申請中"
      else @first_day_monthly_request.selector_monthly_request == 3
        @status_updated = "上長2に申請中"
      end
    elsif @first_day_monthly_request.status_monthly == "承認"
      if @first_day_monthly_request.selector_monthly_request == 2
        @status_updated = "上長1に承認されました"
      else @first_day_monthly_request.selector_monthly_request == 3
        @status_updated = "上長2が承認されました"
      end
    elsif @first_day_monthly_request.status_monthly == "否認"
      if @first_day_monthly_request.selector_monthly_request == 2
        @status_updated = "上長1に否認されました"
      else @first_day_monthly_request.selector_monthly_request == 3
        @status_updated = "上長2に否認されました"
      end
    end
   
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = '新規作成に成功しました。'
      redirect_to @user
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "ユーザー情報を更新しました。"
      redirect_to @user
    else
      render :edit      
    end
  end

  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}のデータを削除しました。"
    redirect_to users_url
  end

  def edit_basic_info
  end

  def update_basic_info
    if @user.update_attributes(user_params)
      flash[:success] = "#{@user.name}の基本情報を更新しました。"
    else
      flash[:danger] = "#{@user.name}の更新は失敗しました。<br>" + @user.errors.full_messages.join("<br>")
    end
    redirect_to users_url
  end

  def edit_overtime_approval # 残業申請への返答 表示
    # @userは自身(上長1または上長2)
    @user = User.find(params[:user_id])
    @users = User.joins(:attendances).group("users.id").where(attendances: { status_overtime: "申請中" })
    # 自身宛てのattendanceのみを表示させる
    @attendances = Attendance.where(selector_overtime_request: @user.id, status_overtime: "申請中")
    
  end

  def update_overtime_approval # 残業申請への返答 更新
    @user = User.find(params[:user_id])
    @attendances = Attendance.where(selector_overtime_request: @user.id, status_overtime: "申請中")
    
    ActiveRecord::Base.transaction do
     overtime_approval_params.each do |id, item|
      attendance = Attendance.find(id)
      if item[:status_overtime] == '承認'
        attendance.update_attributes!(item)
      end
    
     end
     flash[:success] = "残業申請の内容について更新しました。"
     redirect_to @user
    rescue ActiveRecord::RecordInvalid
      flash[:danger] = "無効な入力データがあった為、更新をキャンセルしました。"
      redirect_to user_edit_overtime_approval_path(@user)
    end
    
  end

  def edit_working_hours_approval
    @user = User.find(params[:user_id])
    @users = User.joins(:attendances).group("users.id").where(attendances: { status_working_hours: "申請中" })
    @attendances = Attendance.where(selector_working_hours_request: @user.id, status_working_hours: "申請中")
    
  end

  def update_working_hours_approval
    @user = User.find(params[:user_id])
    @users = User.joins(:attendances).group("users.id").where(attendances: { status_working_hours: "申請中" })
    @attendances = Attendance.where(selector_working_hours_request: @user.id, status_working_hours: "申請中")
    
    ActiveRecord::Base.transaction do
      
      # itemにはform_withで入力されたparamsの値が入っている
      working_hours_approval_params.each do |id, item|
        # attendanceにはidから見つけたattendanceのデータベースの値が入る
        attendance = Attendance.find(id)
        
        # 以下で、form_withには入っていない属性をitemに入れると、ストロングパラメーターで許可された属性のみupdate_attributes!(item)でデータベースに保存される
        # itemに入っていない属性はupdate_attributes!(item)ではデータベースには保存されない
        
        # 「申請中」を選択しても何も変化無し、上長のお知らせは消えない
        # 「否認」を選択してもparameterは変化無し、上長のお知らせが消える

        # 「承認」を選択すると、parameterの値はデータベースに保存される
        if item[:status_working_hours] == "承認"
          # 以下の値をitemに新たに追加する
          item[:started_at_before] = attendance.started_at if attendance.started_at.present?
          item[:finished_at_before] = attendance.finished_at if attendance.finished_at.present?
          item[:started_at] = attendance.started_at_edited
          item[:finished_at] = attendance.finished_at_edited
        end
        # 「なし」を選択すると、parameterの値が全部削除される
        if item[:status_working_hours] == "なし"
          # パラメーターに残っている以下の値を削除する
          attendance.started_at_edited = nil
          attendance.finished_at_edited = nil
          attendance.note = nil
          attendance.selector_working_hours_request = nil
        end
        attendance.update_attributes!(item)
      end
    end
    
    flash[:success] = "勤怠情報の変更について更新しました。"
    redirect_to @user and return
      
  rescue ActiveRecord::RecordInvalid
      flash[:danger] = "無効なデータがあったため、更新をキャンセルしました"
      redirect_to user_edit_working_hours_approval_path(@user) and return
  end
    

  def attendance_confirmation
    @worked_sum = @attendances.where.not(started_at: nil).count
  end

  private

  def overtime_approval_params
    params.require(:user).permit(attendances: [:status_overtime, :change_overtime])[:attendances]
  end

  def working_hours_approval_params
    params.require(:user).permit(attendances: [:started_at_before, :finished_at_before, :started_at, :finished_at, :started_at_edited, :finished_at_edited, :status_working_hours, :change_working_hours])[:attendances]
  end

  
end