q1 = Card.arel_table
q2 = Card.arel_table

night = q1[:name].matches("%night%")
hawk = q1[:name].matches('%hawk%')
mud = q1[:name].matches('%mud%')
mix = q1[:name].matches('%mix%')

term = night.and(hawk).or(q1.grouping(mud.and(mix))).and(q1[:newest].eq(true))
term.to_sql
Card.where(term).count

SELECT COUNT(*) FROM "cards" WHERE (
  ("cards"."name" IS NOT NULL OR 
    ("cards"."name" IS NOT NULL AND 
      ("cards"."name" LIKE '%vamp%') AND 
      ("cards"."name" LIKE '%night%')
    )
  ) AND ("cards"."name" IS NOT NULL AND 
    ("cards"."name" IS NOT NULL AND 
      ("cards"."name" LIKE '%mud%') AND 
      ("cards"."name" LIKE '%mix%')
      )))
      
"(o:transmute mud) OR (vamp o:lifelink night)"

'("cards"."text" LIKE "%transmute%" AND "cards"."name" LIKE "%mud%") OR ("cards"."name" LIKE "%vamp%" AND "cards"."text" LIKE "%lifelink%" AND "cards"."name" LIKE "%night%")'

search_str = "(o:transmute mud) OR (vamp o:lifelink night)"

search_str = fix_quotes search_str
search_str.gsub!('(', ' ( ').gsub!(')', ' ) ')
search_str = fix_naked_terms search_str

def fix_naked_terms str
  arr = str.split(' ')
  puts arr
  immune = ["AND","OR","NOT", "(", ")"]
  prepend_regex = /o:|t:|n:/
  arr.map! do |e|
    unless immune.include?( e ) || e.index(prepend_regex) == 0
      e = "n:" + e
    end
    e
  end
  arr.join(' ')
end

q = '"cards"."text" LIKE ? AND "cards"."text" LIKE ?'
Card.where(q, *['%transmute%', '%destroy%'])


hsh = {

"ding" => "bat",
:doop => :dop
  
}