class Deck < ActiveRecord::Base
  belongs_to :user
  has_many :piles, dependent: :destroy
  has_many :cards, through: :piles
  has_many :synergies, through: :piles
  
  def mainboard_cards *columns
    fetch_board "mainboard", *columns
  end
  
  def sideboard_cards *columns
    fetch_board "sideboard", *columns
  end
  
  def sideboard
    fetch_piles "sideboard"
  end
  
  def mainboard
    fetch_piles "mainboard"
  end
  
  private
  
    def fetch_piles board
      self.piles.where(board: board).reject{|pile| pile.count < 1}.sort_by{|pile| pile.name}
    end
  
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
