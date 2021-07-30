class CreateAwards < ActiveRecord::Migration[5.2]
  def change
    create_table :awards do |t|
      t.string :name, null: false
      t.references :question, foreign_keys: true
      t.references :user, foreign_keys: true, null: true

      t.timestamps
    end
  end
end
