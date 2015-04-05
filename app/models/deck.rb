class Deck < ActiveRecord::Base
  belongs_to :user
  has_many :piles, dependent: :destroy
  has_many :cards, through: :piles
  has_many :synergies, through: :piles
  
  def mainboard *columns
    fetch_board "mainboard", *columns
  end
  
  def sideboard *columns
    fetch_board "sideboard", *columns
  end
  
  private
  
    def fetch_board board_type, *columns
      piles = self.piles.where(board: board_type)
      cards = []
      piles.each do |pile|
        card_id = pile.card_id
        card = !columns.empty? ? Card.where(id: card_id).pluck(*columns).first : Card.find(card_id)
        pile.count.times {cards << card}
      end
      cards
    end
  
end
