# this works so far...
# checks all the set files and then creates expansion objects for each..
# adds all cards in that expansion, and links them.
path = Rails.root.to_s + '/db/all_sets/'
Dir.foreach(path) do |file_name|
  next if file_name == '.' or file_name == '..'
  
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
      if k == "imageName"
        v = "#{new_exp.code.downcase}_#{v}".gsub(' ','_')
      end
      k = 'card_type' if k == 'type'
      k = 'multiverse_id' if k == 'multiverseid'
      property = k.underscore.to_sym
      card_update_hash[property] = v
    end
    
    new_card = Card.new
    new_card.update_attributes card_update_hash
    new_card.expansion = new_exp
    new_card.save
  end

end

#Tag cards as the newest

all_names = []

Card.find_each do |card|
  all_names << card.name
end

unique_names = all_names.uniq

non_unique_names = all_names

unique_names.each do |name|
  i = non_unique_names.index name
  non_unique_names[i] = nil
end

non_unique_names.compact!
non_unique_names.uniq!


non_unique_names.each do |name|
  Card.where(name: name).update_all(newest: false)
  
  printings = Card.where(name: name)
  
  printings = printings.sort_by do |printing|
    printing.expansion.release_date.to_date
  end
  
  printings.last.update(newest: true)
  
end