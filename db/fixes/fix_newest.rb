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