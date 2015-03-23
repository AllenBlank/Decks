class CardsController < ApplicationController
  before_action :set_card, only: [:show]

  # GET /cards
  # GET /cards.json
  def index
    @search = params[:search]
    if @search
      @search.downcase!
      @cards = Card.where("lower(name) LIKE ?", "%#{@search}%")
               .where(newest: true)
               .paginate(page: params[:page], per_page: 5)
    else
      @cards = Card.paginate(page: params[:page], per_page: 5)
    end
    redirect_to @cards.first if @cards.count == 1
  end

  # GET /cards/1
  # GET /cards/1.json
  def show
    respond_to do |format|
      format.html
      format.json { render json: @card }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_card
      @card = Card.find(params[:id])
    end
    
end
