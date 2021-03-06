class DecksController < ApplicationController
  before_action :set_deck, only: [:show, :edit, :update, :destroy]
  before_action :set_cards, only: [:show, :edit]
  before_action :check_logged_in, only: [:edit, :update, :destroy, :new]
  before_action :check_correct_user, only: [:edit, :update, :destroy]
  respond_to :html

  def index
    @user = User.find( params[:user_id] )
    @decks = @user.decks.
                    order(updated_at: :desc).
                    paginate(page: params[:page], per_page: 10)
  end

  def show
    respond_to do |format|
      format.html { respond_with @deck }
      format.js { render @deck }
      format.json { render @deck }
    end
  end

  def new
    @deck = Deck.create user_id: current_user.id
    redirect_to edit_deck_path(@deck)
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
      format.html { redirect_to @deck }
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
    
    def set_cards
      @cards = @deck.cards if (@deck.cards && @deck.cards.count > 0)
    end

    def deck_params
      params.require(:deck).permit(:id, :user_id, :format, :commander, :name, :description)
    end
    
    def check_correct_user
      bounce_chumps "You're the wrong user for that." unless current_user == @deck.user || is_admin?
    end
    
    def add_or_remove_card
      pile = @deck.piles.find_or_create_by( card_id: params[:card], board: params[:location] )
      if params[:add_card]
        pile.update count: pile.count + 1
      elsif params[:remove_card]
        pile.update count: pile.count - 1 unless pile.count == 0
      elsif params[:remove_all]
        pile.update count: 0
      end
    end
end
