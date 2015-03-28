def fix_naked_terms str
  str.gsub!('(', ' ( ').gsub!(')', ' ) ')
  arr = str.split(' ')
  immune_regex = /\(|\)|AND|OR|NOT|o:|t:|n:|((c|ci)(:|!))|(cmc|pow|tou)(>|<|=)/
  arr.map! do |e|
    unless e.index(immune_regex) == 0
      e = "n:" + e
    end
    e
  end
  arr.join(' ')
end

def fix_quotes quoted
  quoted.gsub!("'", '"')
  quote_regex = /"(.*?)"/
  while quoted[quote_regex]
    substr = quoted[quote_regex]
    index = quoted.index(quote_regex)
    substr.gsub!('"', '$').gsub!(' ', '+')
    quoted[index ... index + substr.length ] = substr
  end
  quoted
end

def fix_ands str
    missing_and_regex = /(?=(?<!OR))(?=(?<!NOT))(?=(?<!AND))(?=(?<!\())\s(?=(?!\)))(?=(?!AND))(?=(?!OR))(?=(?!NOT))/
    str.gsub(missing_and_regex, ' AND ')
end

def fix_comparators str
    arr = str.split(' ')
    comparator_regex = /(cmc|pow|tou)(>|<|=)/
    allowed = /(pow|tou|cmc|\>|\<|\=|\d)/
    translations = {
        "pow" => ' "cards"."power" ',
        "tou" => ' "cards"."toughness" ',
        "cmc" => ' "cards"."cmc" ',
        /(?<=(\>|\<|=))\d+\z/ => " \\0"
    }
    arr.map! do |word|
        if word.index(comparator_regex) == 0
            word = "" unless word.gsub(allowed, '').empty?
            translations.each do |k,v|
              word.gsub!(k,v)
            end
        end
        word
    end
    arr.join(' ')
end

def re_quote quoted
  quoted.gsub('$', '').gsub('+', ' ')
end

def fix_matches str
    translations = {
        "o:" => '"cards"."text" LIKE ?',
        "n:" => '"cards"."name" LIKE ?',
        "t:" => '"cards"."card_type" LIKE ?'
    }
    arr = str.split(' ')
    vars = []
    arr.map! do |word|
        translations.keys.each do |key|
            if word.index(key) == 0
                word.sub!(key, '')
                word = "%#{ re_quote(word) }%"
                vars << word
                word = translations[key]
                break
            end
        end
        word
    end
    {query: arr.join(' '), vars: vars}
end

def fix_colors str
  color_regex = /(?!>(\A|\s))((c|ci)(:|!))([wubrg]+)/
  color_map = {
    "w" => 'White',
    "u" => 'Blue',
    "b" => 'Black',
    "r" => 'Red',
    "g" => 'Green'
  }
  while colors = str[color_regex]
  
    colors[":"] ? operator = 'OR' : operator = 'AND'
    colors["ci"] ? column = 'color_id' : column = 'colors'
    colors.gsub!( /((c|ci)(:|!))/, '')
    replacement = ''
    colors.split('').each do |color|
      replacement.concat('"cards"."' + column + '" LIKE "%' + color_map[color] + '%' + " #{operator} ")
    end
    replacement = replacement[0...-(operator.length + 1)]
    
    if operator == 'AND'
        not_string = ' NOT ('
        color_map.keys.each do |key|
            unless colors[key]
                not_string.concat('"cards"."' + column + '" LIKE "%' + color_map[key] + '%' + " OR ")
            end
        end
        not_string = not_string[0...-3]
        replacement.concat not_string
    end
    replacement = "(#{ replacement })"
    str.sub!( color_regex, replacement )
  end
  str
end

search_str = '(o:transmute "muddle the mixture") ci!bug OR (vamp o:lifelink night) cmc>=2'

search_str = fix_quotes search_str
search_str = fix_naked_terms search_str
search_str = fix_ands search_str
search_str = fix_colors search_str
search_str = fix_comparators search_str
query_hash = fix_matches search_str

Card.where( query_hash[:query], *query_hash[:vars] )