Card.update_all "color_id = colors"

colors = { 
  "White" => ["{W","W}"], 
  "Blue"  => ["{U","U}"], 
  "Black" => ["{B","B}"], 
  "Red"   => ["{R","R}"], 
  "Green" => ["{G","G}"]
}

card = Card.arel_table
colors.each do |color, symbols|
  query = card[:text].matches("%#{ symbols[0] }%").
           or( card[:text].matches("%#{ symbols[1] }%") ).
      
           and( 
            card[:color_id].does_not_match("%#{ color }%").
            or( card[:color_id].eq(nil) )
           )
             
  results = Card.where(query)
  results.find_each do |result|
    result.color_id ||= []
    result.color_id << color
    result.save
  end
end
  
  
#     color = "Blue"
#     symbols = ["{U","U}"]
#     card = Card.arel_table
#     query = card[:text].matches("%#{ symbols[0] }%").
#       or(  card[:text].matches("%#{ symbols[1] }%") ).
#       and( card[:color_id].does_not_match("%#{ color }%" ) ).
#       and( card[:name].eq("Memnarch"))
       
# Card.where(name: "Memnarch").where( 
#                               card[:text].matches("%#{ '{U' }%").
#                               or(
#                                 card[:text].matches("%#{ 'U}' }%") 
#                               ).
#                               and(
#                                 card[:color_id].does_not_match("%#{ 'Blue' }%" ) 
#                               )
#                             )
                            
# Card.where(name: "Memnarch").where( card[:color_id].does_not_match("%#{ 'Blue' }%" ) )