class CardsController < ApplicationController
  before_action :set_card, only: [:show]

  autocomplete :card, :name, limit: 10
  def get_autocomplete_items(parameters)
    items = super(parameters)
    items.where(newest: true)
  end
  
  # GET /cards
  # GET /cards.json
  def index
    @cards = query_cards search_params
    #byebug
    redirect_to @cards.first if @cards.count == 1
  end

  # GET /cards/1
  # GET /cards/1.json
  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_card
      @card = Card.find(params[:id])
    end
    
    def query_cards safe_params
      
      cards = Card.where(newest: true).order(name: :asc)
      cards = query_if(cards, safe_params[:card_name], 'name')
      cards = query_if(cards, safe_params[:card_type], 'card_type')
      cards = query_if(cards, safe_params[:card_text], 'text')
      
      cards.paginate(page: safe_params[:page], per_page: 10)
    end
    
    def query_if (cards, param, column)
      if param.present?
        terms = param.gsub(',','').split(' ')
        terms.each { |term| cards = cards.where("lower(#{column}) LIKE ?", "%#{term.downcase}%") }
      end
      cards
    end
    
    def search_params
      params.permit(:card_name, :card_text, :card_type, :page)
    end
    
end
