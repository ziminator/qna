class ChangeColumnNameAnswers < ActiveRecord::Migration[5.2]
  def change
    rename_column :answers, :user_id, :author_id
  end
end
