class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :logged_in_user, only: [:index, :show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:index, :destroy, :edit_basic_info, :update_basic_info]
  before_action :non_admin_user, only: :show
  before_action :set_one_month, only: :show

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
    @worked_sum = @attendances.where.not(started_at: nil).count
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
    if @user.update_attributes(basic_info_params)
      flash[:success] = "#{@user.name}の基本情報を更新しました。"
    else
      flash[:danger] = "#{@user.name}の更新は失敗しました。<br>" + @user.errors.full_messages.join("<br>")
    end
    redirect_to users_url
  end

  def edit_overtime_response # 残業申請への返答 表示
    # @userは自身(上長1または上長2)
    @user = User.find(params[:user_id])
    # 自身宛てのattendanceのみを表示させる
    @attendances = Attendance.where(overtime_request_superior: @user.id)
  end

  def update_overtime_response # 残業申請への返答 更新
    @user = User.find(params[:user_id])
    @attendances = Attendance.where(overtime_request_superior: @user.id)
    
    ActiveRecord::Base.transaction do
     overtime_response_params.each do |id, item|
      attendance = Attendance.find(id)
      if item[:overtime_response_superior] == '承認'
        attendance.update_attributes!(item)
      end
      # if item[:overtime_response_superior] == '否認'
        
      # end
     end
     flash[:success] = "残業申請の内容について更新しました。"
     redirect_to @user
    rescue ActiveRecord::RecordInvalid
      flash[:danger] = "無効な入力データがあった為、更新をキャンセルしました。"
      redirect_to user_edit_overtime_response_path(@user)
    end
    
  end

  def edit_working_hours_response
    @user = User.find(params[:user_id])
    @attendances = Attendance.where(working_hours_request_superior: @user.id)
  end

  def update_working_hours_response
    @user = User.find(params[:user_id])
    @attendances = Attendance.where(working_hours_request_superior: @user.id)
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :affiliation, :password, :password_confirmation, :uid, :employee_number)
    end

    def basic_info_params
      params.require(:user).permit(:affiliation, :basic_work_time)
    end

    def overtime_response_params
      params.require(:user).permit(attendances: [:overtime_response_superior, :change])[:attendances]
    end

    # beforeフィルター

    
end