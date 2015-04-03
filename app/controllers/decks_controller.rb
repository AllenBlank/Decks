class DecksController < ApplicationController
  before_action 
  before_action :set_deck, only: [:show, :edit, :update, :destroy]
  before_action :check_logged_in, only: [:edit, :update, :destroy, :new]
  before_action :check_correct_user, only: [:edit, :update, :destroy]
  

  respond_to :html

  def index
    @decks = Deck.all
    respond_with(@decks)
  end

  def show
    respond_with(@deck)
  end

  def new
    @deck = Deck.new
    respond_with(@deck)
  end

  def edit
  end

  def create
    @deck = Deck.new(deck_params)
    @deck.user = current_user
    @deck.save
    redirect_to edit_deck_path(@deck)
  end

  def update
    @deck.update(deck_params)
    respond_with(@deck)
  end

  def destroy
    @deck.destroy
    respond_with(@deck)
  end

  private
    def set_deck
      @deck = Deck.find(params[:id])
    end

    def deck_params
      params.require(:deck).permit(:user_id, :format, :commander, :name, :description)
    end
    
    def check_correct_user
      bounce_chumps "You're the wrong user for that." unless current_user == @deck.user || is_admin?
    end
end
