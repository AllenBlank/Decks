module DecksHelper
  def counted_cards_by_type_array
    cards = @deck.mainboard.sort_by {|card| card.name}
    
    types = cards_by_type( cards )
    
    types.each do |type, card_list|
      types[type] = cards_by_count( card_list )
    end
    
    types_array = []
    types.each {|k,v| types_array << {k => v} }
    types_array
  end
  
  def cards_by_count card_list
    # Get rid of duplicate cards
    counts_hash = Hash.new(0)
    card_list.each {|card| counts_hash[card] +=1 }
    counts_hash
  end
  
  def cards_by_type card_list
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
    card_list.each do |card|
      sorted = false
      types.each do |type, list|
        if card.card_type[type] && type != "Other"
          types[type] << card
          sorted = true
          break
        end
      end
      types["Other"] << card unless sorted
    end
    
    # Get rid of types with no cards.
    types.select {|k,v| !v.empty? }
  end

end