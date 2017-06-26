class CreateTests < ActiveRecord::Migration[5.0]
  def change
    create_table :tests do |t|
      t.references :user, foreign_key: true
      t.integer :score
      t.datetime :test_date
      t.datetime :ended_at

      t.timestamps
    end
  end
end
