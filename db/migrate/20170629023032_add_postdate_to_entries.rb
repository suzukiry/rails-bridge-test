class AddPostdateToEntries < ActiveRecord::Migration[5.0]
  def change
    add_column :entries, :post_date, :date
  end
end
