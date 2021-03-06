def fix_naked_terms str
  str.gsub!('(', ' ( ')
  str.gsub!(')', ' ) ')
  arr = str.split(' ')
  immune_regex = /\(|\)|AND|OR|NOT|(o|t|n|c|ci)(:|!)|(cmc|pow|tou)(>|<|=)/
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

def re_quote quoted
  quoted.gsub('$', '').gsub('+', ' ')
end

def fix_ands str
    missing_and_regex = /(?=(?<!OR))(?=(?<!AND))(?=(?<!\())\s(?=(?!\)))(?=(?!AND))(?=(?!OR))/
    str.gsub(missing_and_regex, ' AND ')
end

def build_query str
  immune_terms = [')','(','AND','OR']
  operators = /[:|!|>|<|=]+/
  color_types = /(c|ci)(:|!)/
  
  dictionary = {
    'o'   => ' "cards"."text" ',
    't'   => ' "cards"."card_type" ',
    'n'   => ' "cards"."name" ',
    'pow' => ' "cards"."power" ',
    'tou' => ' "cards"."toughness" ',
    'cmc' => ' "cards"."cmc" ',
    ':'   => ' LIKE ',
    '!:'   => ' NOT LIKE '
  }
  args = []
  
  terms = str.split(' ')
  terms.map! do |term|
    unless immune_terms.include? term
      if term.index(color_types) == 0
        term = build_color_query( term ) 
      else
        operator = term[operators]
        parts = term.split(operators)
        parts.map! do |part|
          if dictionary.keys.include? part
            part = dictionary[part]
          else
            args << part
            part = ' ? '
          end
          part
        end
        operator = dictionary[operator] if dictionary.keys.include? operator 
        term = parts.join(" #{operator} ")
      end
    end
    term
  end
  args.map! do |var|
    if var.to_i.to_s == var
      var = var.to_i
    else
      var = re_quote var
      var = "%#{var}%"
    end
    var
  end
  terms = terms.join(' ').split(' ').join(' ')
  {query: terms, args: args}
end

def build_color_query term

  color_regex = /(?!>(\A|\s))((c|ci)(:|!))([wubrg]+)/
  operator_regex = /(c|ci)(:|!)/
  
  return '' unless term[color_regex] == term
  
  term["!"]  ? mode = 'exclusive' : mode = 'inclusive'
  term["ci"] ? col  = 'color_id'  : col =  'colors'
  colors = term.gsub(operator_regex, '').split('')
  
  color_map = {
    "w" => 'White',
    "u" => 'Blue',
    "b" => 'Black',
    "r" => 'Red',
    "g" => 'Green'
  }
  
  color_query = ''
  color_map.each do |color_letter,color_name|
    case mode
    when 'exclusive'
      if colors.include? color_letter 
        color_query.concat "'cards'.'#{col}' LIKE '%#{color_name}%' AND "
      else
        color_query.concat "'cards'.'#{col}' NOT LIKE '%#{color_name}%' AND "
      end
    when 'inclusive'
      case col
      when 'colors'
        if colors.include? color_letter 
          color_query.concat "'cards'.'#{col}' LIKE '%#{color_name}%' OR "
        end
      when 'color_id'
        unless colors.include? color_letter
          color_query.concat "'cards'.'#{col}' NOT LIKE '%#{color_name}%' AND"
        end
      end
    end
  end
  color_query.gsub!(/(AND|OR)\s*\z/, '')
  "( #{color_query} )"
end

search_str = 't:legend ci!ub'

search_str = fix_quotes search_str
search_str = fix_naked_terms search_str
search_str = fix_ands search_str
query_hash = build_query search_str

results = Card.where( query_hash[:query], *query_hash[:args] )
results.each do |result|
  puts result.name
end