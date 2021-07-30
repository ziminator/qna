class ChangeColumnNameQuestions < ActiveRecord::Migration[5.2]
  def change
    rename_column :questions, :user_id, :author_id
  end
end
