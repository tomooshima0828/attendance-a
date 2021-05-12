class CreateAttendances < ActiveRecord::Migration[5.1]
  def change
    create_table :attendances do |t|
      t.date :worked_on
      t.datetime :started_at
      t.datetime :finished_at
      t.string :note

      # t.datetime :started_at_previously # 変更前出社時間
      # t.datetime :finished_at_previously # 変更前退社時間

      # t.datetime :started_at_changed # 変更後出社時間
      # t.datetime :finished_at_changed # 変更後退社時間

      # t.datetime :estimated_overtime_hours # 終了予定時間 残業申請
      # t.string :business_process_content # 業務処理内容 残業申請
      
      # t.boolean :next_day_overtime, default: false # 翌日 残業申請
      # t.boolean :next_day_attendance, default: false # 翌日 勤怠編集画面

      # t.integer :overtime_request_superior, null: false, default: 0 # 残業申請の指示者確認　上長(上長1または上長2)が入る
      # t.string :overtime_response_superior # 残業申請　指示者確認印　[['なし'], ['申請中'], ['承認'], ['否認']]のいずれかが入る

      # t.integer :working_hours_request_superior, null: false, default: 0 # 勤怠変更の指示者確認　上長(上長1または上長2)が入る
      # t.string :working_hours_response_superior #勤怠変更申請　指示者確認印　[['なし'], ['申請中'], ['承認'], ['否認']]のいずれかが入る

      # t.integer :one_month_request_superior, null: false, default: 0 # 1ヶ月分の勤怠変更の指示者確認　上長(上長1または上長2)が入る
      # t.string :one_month_response_superior # 〇〇からの1ヶ月分の勤怠変更申請　[['なし'], ['申請中'], ['承認'], ['否認']]が入る
      
      # t.references :user, foreign_key: true

      # t.boolean :change, default: false # 変更

      # t.datetime :year_starting # 最初の年
      # t.datetime :year_ending # 最後の年

      # t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
