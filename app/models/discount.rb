class Discount <ApplicationRecord
  validates_presence_of :name,
                        :threshold,
                        :percent_off
                       
  belongs_to :merchant
  
  validates :percent_off, :inclusion => 1..100
  # validates_numericality_of :percent_off, greater_than_or_equal_to: 1
end