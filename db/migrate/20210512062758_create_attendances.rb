class CreateAttendances < ActiveRecord::Migration[5.1]
  def change
    create_table :attendances do |t|
      t.date :worked_on
      t.datetime :started_at
      t.datetime :finished_at
      t.string :note

      t.datetime :started_at_before # 変更前出社時間
      t.datetime :finished_at_before # 変更前退社時間

      t.datetime :started_at_edited # 変更後出社時間
      t.datetime :finished_at_edited # 変更後退社時間

      t.datetime :estimated_overtime_hours # 終了予定時間 残業申請
      t.string :business_process_content # 業務処理内容 残業申請
      
      t.boolean :next_day_overtime, default: false # 翌日 残業申請
      t.boolean :next_day_working_hours, default: false # 翌日 勤怠編集画面

      t.integer :selector_overtime_request, default: 0 # 残業申請の指示者確認　上長(上長1または上長2)が入る
      t.string :selector_overtime_approval # 残業申請　指示者確認印　[['なし'], ['申請中'], ['承認'], ['否認']]のいずれかが入る

      t.integer :selector_working_hours_request, default: 0 # 勤怠変更の指示者確認　上長(上長1または上長2)が入る
      t.string :selector_working_hours_approval #勤怠変更申請　指示者確認印　[['なし'], ['申請中'], ['承認'], ['否認']]のいずれかが入る

      t.integer :selector_monthly_request, default: 0 # 1ヶ月分の勤怠変更の指示者確認　上長(上長1または上長2)が入る
      t.string :selector_monthly_approval # 〇〇からの1ヶ月分の勤怠変更申請　[['なし'], ['申請中'], ['承認'], ['否認']]が入る
      t.date :date_monthly_request
      
      t.boolean :change_overtime, default: false # 変更 残業
      t.boolean :change_working_hours, default: false # 変更 勤怠
      t.boolean :change_monthly, default: false # 変更 1ヶ月

      t.string :status_overtime_request
      t.string :status_working_hours_request
      t.string :status_monthly_request

      t.datetime :year_starting # 最初の年
      t.datetime :year_ending # 最後の年

      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
