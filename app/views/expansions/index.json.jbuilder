json.array!(@expansions) do |expansion|
  json.extract! expansion, :id, :name, :code, :magic_rarities_codes, :release_date, :border, :type, :cards, :old_code, :gatherer_code, :block, :booster, :online_only
  json.url expansion_url(expansion, format: :json)
end
