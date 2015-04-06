class SynergiesController < ApplicationController
  before_action :set_deck,  only: [:index]
  before_action :set_piles, only: [:create, :destroy]

  def create
    if params[:type] = "many-to-many"
      @piles << @center_pile if @center_pile
      @piles.each_with_index do |pile, i|
        (i...piles.length).each do |j|
          pile.compliments << piles[j]
        end
      end
    else
      @piles.each {|pile| @center_pile.compliments << pile}
    end
      render json: {}
  end

  def destroy
    @piles << @center_pile if @center_pile
    @piles.each do |pile|
      @piles.each do |compliment|
        pile.compliments.delete( compliment ) if pile.compliments.include? compliment
      end
    end
  end

  def index
    links = gen_unique_links
    links = format_links links
    piles_with_synergies = @deck.piles.reject {|pile| pile.compliments.empty? }
    nodes = format_nodes piles_with_synergies
    render json: {links: links, nodes: nodes}
  end
  
  private
    
    def set_deck
      @deck = Deck.find(params[:deck_id])
    end
    
    def set_piles
      @piles = params[:pile_ids].map { |pile| Pile.find(pile) }
      @center_pile = params[:center_pile] ? pile.find(params[:center_pile]) : nil 
    end
    
    def format_nodes piles
      piles.map do |pile|
        id = pile.id
        name = Card.find(pile.card_id).name
        { data: { id: id,  name: name } }
      end
    end
  
    def format_links links
      links.map do |link|
        source = Pile.find( link[0] ).id
        target = Pile.find( link[1] ).id
        { data: { source: source, target: target } }
      end
    end
  
    def gen_unique_links
      links = @deck.synergies.pluck(:pile_id, :compliment_id)
      reverse_links = []
      links.select do |link|
        unless reverse_links.include? link
          reverse_links << link.reverse
        else
          false
        end
      end
    end
end
