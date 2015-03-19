json.array!(@cards) do |card|
  json.extract! card, :id, :layout, :type, :types, :colors, :name, :rarity, :cmc, :mana_cost, :text, :flavor, :artist, :rulings, :legalities, :number, :foreign_names, :source, :image_name, :printings, :release_date, :subtypes, :power, :toughness, :names, :supertypes, :multiverseid, :original_type, :original_text, :variations, :reserved, :loyalty, :border, :watermark, :timeshifted, :starter, :hand, :life
  json.url card_url(card, format: :json)
end
