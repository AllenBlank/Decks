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
      if safe_params[:card_name].present?
        terms = safe_params[:card_name].split(' ')
        terms.each { |term| cards = cards.where("lower(name) LIKE ?", "%#{term.downcase}%") }
      end
      if safe_params[:card_text].present?
        terms = safe_params[:card_text].split(' ')
        terms.each { |term| cards = cards.where("lower(text) LIKE ?", "%#{term.downcase}%") }
      end
      cards.paginate(page: params[:page], per_page: 10)
    end
    
    def search_params
      params.permit(:card_name, :card_text)
    end
    
end
