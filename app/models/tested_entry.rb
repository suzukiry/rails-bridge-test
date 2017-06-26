class TestedEntry < ApplicationRecord
  belongs_to :test
  belongs_to :entry
  
  validates :test_id, presence: true
  validates :entry_id, presence: true
  
  def previous
    TestedEntry.where("id < ?", self.id).order("id DESC").first
  end
 
  def next
    TestedEntry.where("id > ?", self.id).order("id ASC").first
  end
  
end
