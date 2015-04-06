class Synergy < ActiveRecord::Base
  belongs_to :pile, class_name: "Pile"
  belongs_to :compliment, class_name: "Pile"
  before_save :no_loopbacks
  after_save :complete_link
  
  private
    def no_loopbacks
      self.pile != self.compliment
    end
    
    def complete_link
      unless self.compliment.compliments.include? self.pile
        self.compliment.compliments << self.pile
      end
    end
end
