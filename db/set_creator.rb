# this works so far...
# changed the path afterwards, not 100% sure it'll work.
# checks all the set files and then creates expansion objects for each..
count = 0
path = Rails.root.to_s + '/db/all_sets/'
Dir.foreach(path) do |file_name|
  next if file_name == '.' or file_name == '..'
  
  count += 1
  break if count > 1
  
  json = File.new( path + file_name, 'r')
  hash = JSON.parse(json.read)
  json.close
  
  update_hash = {}
  hash.each do |k,v|
    next if k == "cards"
    k = 'expansion_type' if k == 'type'
    property = k.underscore.to_sym
    update_hash[property] = v
  end
  
  new_exp = Expansion.new
  new_exp.update_attributes update_hash
  new_exp.save
  
  hash["cards"].each do |card|
    card_update_hash = {}
    card.each do |k,v|
      k = 'card_type' if k == 'type'
      property = k.underscore.to_sym
      card_update_hash[property] = v
    end
    
    new_card = Card.new
    new_card.update_attributes card_update_hash
    new_card.expansion = new_exp
    new_card.save
  end

end