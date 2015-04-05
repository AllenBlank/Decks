class Synergy < ActiveRecord::Base
  belongs_to :pile, class_name: "Pile"
  belongs_to :compliment, class_name: "Pile"
  after_save :complete_link
  
  private
    def complete_link
      unless self.compliment.compliments.include? self.pile
        self.compliment.compliments << self.pile
      end
    end
end
