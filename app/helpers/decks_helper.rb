module DecksHelper
  def piles_by_type_array
    piles = @deck.mainboard
    
    types = piles_by_type( piles )

    types_array = []
    types.each {|k,v| types_array << {k => v} }
    types_array
  end
  
  def piles_by_type pile_list
    types = {
      "Creature" => [],
      "Instant" => [], 
      "Sorcery" => [], 
      "Artifact" => [], 
      "Enchantment" => [], 
      "Planeswalker" => [],
      "Land" => [],
      "Other" => []
    }
    
    # For each card, add it to the array of the type it first matches.
    pile_list.each do |pile|
      sorted = false
      types.each do |type, list|
        if pile.card_type[type] && type != "Other"
          types[type] << pile
          sorted = true
          break
        end
      end
      types["Other"] << pile unless sorted
    end
    
    # Get rid of types with no cards.
    types.select {|k,v| !v.empty? }
  end

end