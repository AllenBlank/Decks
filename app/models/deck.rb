class Deck < ActiveRecord::Base
  has_one :sideboard
  has_and_belongs_to_many :cards
  before_create :add_sideboard
  
  private
    def add_sideboard
      self.sideboard = Sideboard.new
    end
end
