class CardsController < ApplicationController
  before_action :set_card, only: [:show]
  include CardsHelper

  autocomplete :card, :name, limit: 10
  def get_autocomplete_items(parameters)
    items = super(parameters)
    items.where(newest: true)
  end
  
  # GET /cards
  # GET /cards.json
  def index
    @cards = query_cards
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
    
    def query_cards
      q = QueryParser.new
      query = Card.where(newest: true).order(name: :asc)
      
      basic_parameters = [:n, :o, :t, :f]
      basic_parameters.each do |sym|
        if safe_params[sym].present?
          prefix = sym.to_s + ':'
          terms = safe_params[sym]
          query = q.adv_query_by_prefix query, prefix, terms
        end
      end
      
      color_parameters = {White: "w", Blue: "u", Black: "b", Red: "r", Green: "g"}
      safe_params[:exact_id].present? ? ci_prefix = 'ci!' : ci_prefix = 'ci:'
      color_query = ''
      color_parameters.each do |color_name, color_char|
        color_query << color_char if safe_params[color_name].present?
      end
      query = q.adv_query_by_prefix(query, ci_prefix, color_query) unless color_query.empty?
      
      query = q.adv_query(query, safe_params[:adv]) if safe_params[:adv].present?
      
      query.paginate(page: safe_params[:page], per_page: 10)
    end
    
    def safe_params
      params.permit(:n, :o, :t, :f, :adv, :White, :Blue, :Black, :Red, :Green, :exact_id, :page)
    end
    
end
