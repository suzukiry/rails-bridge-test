class Test < ApplicationRecord

  belongs_to :user

  validates :user_id, presence: true

  has_many :tested_entries 
  has_many :show_entries, through: :tested_entries, source: :entry

  def populate(random_array)
    random_array.each do |entry_id|
      self.tested_entries.find_or_create_by(entry_id: entry_id)
    end
  end

end
