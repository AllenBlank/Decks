class Synergy < ActiveRecord::Base
  belongs_to :pile, class_name: "Pile"
  belongs_to :compliment, class_name: "Pile"
  
  has_many :tag_pins, dependent: :destroy
  has_many :tags, through: :tag_pins
  
  validate :no_loopbacks
  after_save :complete_link
  
  private
    def no_loopbacks
      errors.add(:pile, "pile can't be the same as compliment") if self.pile == self.compliment
    end
    
    def complete_link
      unless self.compliment.compliments.include? self.pile
        self.compliment.compliments << self.pile
      end
    end
end
