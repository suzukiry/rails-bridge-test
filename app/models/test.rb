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

  def create_entry(test_num, post_type)
    
    random_entry_array = Array.new
    random_entry_array = Entry.where(post_type: post_type)
    p "Before: #{random_entry_array.to_a()}"
    p "Before: #{random_entry_array.class}"

    #random_entry_array.to_a().shuffle!
    
    #random_entry_array = random_entry_array.find(Entry.where(post_type: post_type).pluck(:id).shuffle[0..test_num])
    random_entry_array = Entry.where(post_type: post_type).pluck(:id).shuffle[0..test_num-1]
    #random_entry_array = random_entry_array.to_a().to(test_num-1)
    p "After: #{random_entry_array.to_a()}"

    random_entry_array.each do |entry_id|
      #self.tested_entries.find_or_create_by(entry_id: entry_id)
      self.tested_entries.create(entry_id: entry_id)
    end
  end

end
