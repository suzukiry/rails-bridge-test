class Entry < ApplicationRecord

  validates :eng_word, presence: true
  validates :jpn_word, presence: true
  validates :description, presence: true

  has_many :tested_entries  
  has_many :show_tests, through: :tested_entries, source: :test
 
  has_many :mastered_entries  
  has_many :show_musers, through: :mastered_entries, source: :user

end
