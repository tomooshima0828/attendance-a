class CreateBranchOffices < ActiveRecord::Migration[5.1]
  def change
    create_table :branch_offices do |t|
      t.string :branch_office_name

      t.timestamps
    end
  end
end
