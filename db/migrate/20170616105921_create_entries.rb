class CreateEntries < ActiveRecord::Migration[5.0]
  def change
    create_table :entries do |t|
      t.integer :post_type
      t.string :eng_word
      t.string :jpn_word
      t.text :description
      t.string :youtube_url
      t.string :site_url

      t.timestamps
    end
  end
end
