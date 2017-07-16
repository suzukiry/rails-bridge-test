class TestedEntry < ApplicationRecord
  belongs_to :test
  belongs_to :entry
  
  validates :test_id, presence: true
  validates :entry_id, presence: true

end
