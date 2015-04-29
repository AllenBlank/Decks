class Tag < ActiveRecord::Base
  has_many :tag_pins
  has_many :decks, through: :tag_pins
  has_many :piles, through: :tag_pins
  has_many :synergies, through: :tag_pins
  
  validates :name, presence: true, length: { maximum: 16 }, uniqueness: { case_sensitive: false }
  validates :description, length: { maximum: 140 }
  
  before_save { self.name = self.name.downcase }
end
