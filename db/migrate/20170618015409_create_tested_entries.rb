class CreateTestedEntries < ActiveRecord::Migration[5.0]
  def change
    create_table :tested_entries do |t|
      t.references :test, foreign_key: true
      t.references :entry, foreign_key: true
      t.boolean :result

      t.timestamps

      t.index [:test_id, :entry_id], unique: true

    end
  end
end
