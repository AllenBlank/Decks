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
    respond_to do |format|
      format.html { respond_with @deck }
      format.js { render @deck }
      format.json { render @deck }
    end
  end

  def new
    @deck = Deck.new
    respond_with(@deck)
  end

  def edit
    set_current_deck @deck
  end

  def create
    @deck = Deck.new(deck_params)
    @deck.user = current_user
    @deck.save
    redirect_to edit_deck_path(@deck)
  end

  def update
    if params[:add_remove]
      count = ( params[:full_set] ? 4 : 1 )
      count.times { add_or_remove_card }
    else
      @deck.update_attributes(deck_params)
    end
    
    @deck.save
    
    respond_to do |format|
      format.html { redirect_to edit_deck_path(@deck) }
      format.js { render @deck }
      format.json { render @deck }
    end

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
      params.require(:deck).permit(:id, :user_id, :format, :commander, :name, :description)
    end
    
    def check_correct_user
      bounce_chumps "You're the wrong user for that." unless current_user == @deck.user || is_admin?
    end
    
    def add_or_remove_card
      case params[:location]
      when 'sideboard'
        list = @deck.sideboard.cards
      else
        list = @deck.cards
      end
      card = Card.find( params[:card] )
      if params[:add_card]
        list << card
      elsif params[:remove_all]
        list.delete card
      else
        if list.include? card
          c = list.count
          list.delete(card)
          (c - list.count - 1).times { list << card }
        end
      end
    end
end
