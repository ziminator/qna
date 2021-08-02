class CreateVotes < ActiveRecord::Migration[5.2]
  def change
    create_table :votes do |t|
      t.integer :score, default: 0, null: false
      t.belongs_to :user
      t.belongs_to :votable, polymorphic: true

      t.timestamps
    end
  end
end
