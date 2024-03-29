# frozen_string_literal: true

module AttendancesHelper
  def attendance_state(attendance)
    # 受け取ったAttendanceオブジェクトが当日と一致するか評価します。
    if Date.current == attendance.worked_on
      return '出勤' if attendance.started_at.nil?
      return '退勤' if attendance.started_at.present? && attendance.finished_at.nil?
    end
    # どれにも当てはまらなかった場合はfalseを返します。
    false
  end

  def attendance_state?(attendance)
    Date.current == attendance.worked_on
  end

  # 出勤時間と退勤時間を受け取り、在社時間を計算して返します。
  def working_times(start, finish)
    format('%.2f', (((finish - start) / 60) / 60.0))
  end

  def working_times_next_day(start, finish, next_day)
    if next_day == true
      format('%.2f', ((finish.hour - start.hour) + (finish.min - start.min) / 60.0) + 24)
    else
      format('%.2f', ((finish.hour - start.hour) + (finish.min - start.min) / 60.0))
    end
  end

  def format_hour(time)
    # 2d == two digits 2桁
    format('%.2d', time.hour)
  end

  def format_min(time)
    # 2d == two digits 2桁
    format('%.2d', time.min)
  end
end
