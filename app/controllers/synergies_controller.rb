class SynergiesController < ApplicationController
  before_action :set_deck,  only: [:index]
  before_action :set_piles, only: [:destroy]

  def create
    ids = params[:pile_ids]
    ids.compact!
    ids.each do |pile_id|
      ids.each do |compliment_id|
        Synergy.find_or_create_by(pile_id: pile_id, compliment_id: compliment_id)
      end
    end
    
    render json: {}
  end

  def destroy
    @piles.each do |pile|
      @piles.each do |compliment|
        pile.compliments.delete( compliment ) if pile.compliments.include? compliment
      end
    end
    render json: {}
  end

  def index
    links = gen_unique_links
    links = clear_empty_piles links
    piles = gen_piles_from_links links
    
    edges = format_links links
    nodes = format_nodes piles
    render json: {edges: edges, nodes: nodes}
  end
  
  private
    
    def set_deck
      @deck = Deck.find(params[:deck_id])
    end
    
    def set_piles
      @piles = params[:pile_ids].map { |pile| Pile.find(pile) }
    end
    
    def format_nodes piles
      piles.map do |pile|
        id = pile.id.to_s
        name = Card.find(pile.card_id).name
        { data: { id: id,  name: name } }
      end
    end
  
    def format_links links
      links.map do |link|
        source = Pile.find( link[0] ).id.to_s
        target = Pile.find( link[1] ).id.to_s
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
    
    def clear_empty_piles links
      links.reject do |link|
        Pile.find(link[0]).count == 0 || Pile.find(link[1]).count == 0
      end
    end
    
    def gen_piles_from_links links
      piles = []
      links.each do |link|
        piles << Pile.find(link[0])
        piles << Pile.find(link[1])
      end
      piles.uniq
    end
    
end
