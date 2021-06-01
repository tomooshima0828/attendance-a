class Attendance < ApplicationRecord
  belongs_to :user

  validates :worked_on, presence: true
  validates :note, length: { maximum: 50 }

  # 出勤時間が存在しない場合、退勤時間は無効
  validate :finished_at_is_invalid_without_a_started_at
  # 出勤・退勤時間どちらも存在する時、出勤時間より早い退勤時間は無効
  validate :started_at_than_finished_at_fast_if_invalid

  validate :all_items_must_be_present


  def finished_at_is_invalid_without_a_started_at
    errors.add(:started_at, "が必要です") if started_at.blank? && finished_at.present?
  end

  def started_at_than_finished_at_fast_if_invalid
    
    if next_day_working_hours == false
      if started_at.present? && finished_at.present?
        errors.add(:started_at, "より早い退勤時間は無効です") if started_at > finished_at
      end
    end
    if next_day_working_hours == false
      if started_at_edited.present? && finished_at_edited.present?
        errors.add(:started_at_edited, "より早い退勤時間は無効です") if started_at_edited > finished_at_edited
      end
    end
  end

  def all_items_must_be_present
        
    if (started_at_edited.present? && finished_at_edited.present?) && selector_working_hours_request.blank?
      errors.add(:started_at_edited, "出社時間と退社時間の両方を入力して、上長を選択してください")
    end
    if (started_at_edited.present? && finished_at_edited.blank?) && selector_working_hours_request.blank?
      errors.add(:started_at_edited, "出社時間と退社時間の両方を入力して、上長を選択してください")
    end
    if (started_at_edited.blank? && finished_at_edited.present?) && selector_working_hours_request.blank?
      errors.add(:started_at_edited, "出社時間と退社時間の両方を入力して、上長を選択してください")
    end
    if (started_at_edited.present? && finished_at_edited.present?) && selector_working_hours_request.blank?
      errors.add(:started_at_edited, "出社時間と退社時間の両方を入力して、上長を選択してください")
    end
    if (started_at_edited.present? && finished_at_edited.blank?) && selector_working_hours_request.present?
      errors.add(:started_at_edited, "出社時間と退社時間の両方を入力して、上長を選択してください")
    end
    if (started_at_edited.blank? && finished_at_edited.present?) && selector_working_hours_request.present?
      errors.add(:started_at_edited, "出社時間と退社時間の両方を入力して、上長を選択してください")
    end
  end

end