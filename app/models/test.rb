class Test < ApplicationRecord

  belongs_to :user

  validates :user_id, presence: true

  has_many :tested_entries 
  has_many :show_entries, through: :tested_entries, source: :entry

  def create_entry(test_num, post_type)
    
    # ARでランダムなentry_idを取得
    random_entry_array = Entry.where(post_type: post_type).pluck(:id).shuffle[0..test_num-1]
    p "After: #{random_entry_array.to_a()}"

    # tested_entriesに登録
    random_entry_array.each do |entry_id|
      self.tested_entries.create(entry_id: entry_id)
    end
  end

end
