class Pile < ActiveRecord::Base
  belongs_to :deck
  belongs_to :card
  
  has_many :synergies, class_name:  "Synergy",
                       foreign_key: "pile_id",
                       dependent:   :destroy
  has_many :inversergies, class_name:  "Synergy",
                          foreign_key: "compliment_id",
                          dependent:   :destroy
  has_many :compliments, through: :synergies,  source: :compliment
  
  before_save :set_defaults
  
  def name
    Card.find(self.card_id).name
  end
  def types
    Card.find(self.card_id).types
  end
  
  private
  
    def set_defaults
      self.count ||= 0
    end
end
