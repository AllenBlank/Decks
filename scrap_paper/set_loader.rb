# puts 'Enter set filename:'
# file_name = gets.chomp

file_name = 'scrap_paper/DTK-x.json'
json = File.new( file_name, 'r')
hash = JSON.parse(json.read)
json.close

update_hash = {}
hash.each do |k,v|
  k = 'expansion_type' if k == 'type'
  property = k.underscore.to_sym
  next if k == "cards"
  next if k == "magicCardsInfoCode"
  update_hash[property] = v
end

new_exp = Expansion.new
new_exp.update_attributes update_hash
new_exp.save

hash["cards"].each do |card|
  card_update_hash = {}
  card.each do |k,v|
    if k == "imageName"
      v = "#{new_exp.code.downcase}_#{v}".gsub(' ','_').gsub(',','')
    end
    k = 'card_type' if k == 'type'
    k = 'multiverse_id' if k == 'multiverseid'
    property = k.underscore.to_sym
    card_update_hash[property] = v
  end
  
  new_card = Card.new( card_update_hash )
  new_card.expansion_id = new_exp.id
  
  old_newest = Card.where(name: new_card.name, newest: true).first
  unless old_newest && old_newest.expansion.release_date.to_date > new_card.expansion.release_date.to_date
    new_card.newest = true 
    old_newest.update newest: false if old_newest
  else
    new_card.newest = false
  end
  
  new_card.color_id = new_card.colors
  new_card.color_id ||= []
  
  colors = { 
    "White" => ["{W","W}"], 
    "Blue"  => ["{U","U}"], 
    "Black" => ["{B","B}"], 
    "Red"   => ["{R","R}"], 
    "Green" => ["{G","G}"]
  }
  
  unless new_card.text.nil?
    colors.each do |k,v|
      new_card.color_id << k if new_card.text[ v[0] ] || new_card.text[ v[0] ]
    end
  end
  
  new_card.formats = []
  if new_card.legalities
    new_card.legalities.each do |k,v|
      new_card.formats << k if v == "Restricted" ||  v == "Legal"
    end
  end
  
  new_card.save
  
end