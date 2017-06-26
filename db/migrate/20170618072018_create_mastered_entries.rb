class CreateMasteredEntries < ActiveRecord::Migration[5.0]
  def change
    create_table :mastered_entries do |t|
      t.references :user, foreign_key: true
      t.references :entry, foreign_key: true
      t.boolean :master_flag

      t.timestamps
      
      t.index [:user_id, :entry_id], unique: true
    end
  end
end
