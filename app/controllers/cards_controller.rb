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
    @search = params[:search]
    if @search
      @search.downcase!
      @cards = Card.where("lower(name) LIKE ?", "%#{@search}%")
               .where(newest: true)
               .paginate(page: params[:page], per_page: 10)
    else
      @cards = Card.paginate(page: params[:page], per_page: 10)
    end
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
    
end
