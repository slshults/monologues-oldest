##################################
# parse shakespeare-monologues.org
##################################
require 'nokogiri'
require 'open-uri'
require 'ruby-debug'


def scene_body(reftext)
  return '' unless reftext
  m = reftext.match(/\b([IVX]+) ([ivx1]+) (\d+)\b/)
  if m and m[1] and m[2] and m[3]
    ref = [ m[1], m[2], m[3] ].join
  end
  return ref
end

def parse_monologues(server, mono_page)
  doc = Nokogiri::HTML.parse(open(server + mono_page))
  # puts doc.class.to_s + ' from ' + server + mono_page
  play = doc.xpath('//h1').inner_text.strip
  monologue_table = doc.xpath('//tr')
  #monologue_table = doc.xpath('//table[1]').children[1]
  #puts monologue_table.children.size
  monos = []
  monologue_table.each do |row|
    next unless row.to_s.match(/\bProse\b|\bVerse\b/)
    nodes = row.children.select{|n| n.class == Nokogiri::XML::Element }
    if nodes[0].inner_text.length < 200
      character = nodes[0].inner_text.sub(/intercut/, ' (intercut)').strip
      type = nodes[1].inner_text.strip rescue ''
      name = nodes[2].xpath('i')[0].inner_text.strip rescue ''
      reftext = nodes[3].xpath('a').inner_text.strip rescue ''
      reflink = nodes[3].xpath('a')[0].attributes['href'].text.strip rescue ''
      fc = nodes[4].xpath('script').to_html rescue ''
      mono = [character, type, name, reftext, reflink, fc]
      monos << mono
  #    puts server + mono_page + ref + '.htm' if ref
    end
  end
  return [monos, play]
end

def insert_monologues(server, mono_page, monos)
  monos.each do |mono|
    shake = Author.find_by_name('Shakespeare')
    hamlet = Play.find_by_title('Hamlet')
    case mono_page
    when /^\/men/
      gender = 3
    when /^\/women/
      gender = 2
    end
    begin
      body = open(server + mono_page + scene_body(mono[3]) + '.htm').read
      Monologue.create!(
        :play_id => hamlet.id,
        :name => mono[2],
        :character => mono[0],
        :gender_id => gender,
        :style => mono[1],
        :body => body,
        :section => mono[3],
        :link => mono[4]
      )
      puts "Added #{mono[2]}"
    rescue => e
      #logger.warn "Error adding monologe: #{mono[2]}\n e.message"
      puts "Error adding monologe: #{mono[2]}\n e.message"
    end
  end
end

def insert_play(play)
  Play.create(:title => play, :author_id => 1)
end

server = 'http://shakespeare-monologues.org'
mono_pages = ['/women/hamlet/', '/men/hamlet/',
  '/women/midsummer/', '/men/midsummer/',
  '/women/macbeth/', '/men/macbeth/',
  '/women/AllsWell/', '/men/AllsWell/',
  '/women/AsYouLikeIt/', '/men/AsYouLikeIt/',
  '/women/Errors/', '/men/Errors/',
  '/women/Cymbeline/', '/men/Cymbeline/',
  '/women/LLL/', '/men/LLL/',
  '/women/merchant/', '/men/merchant/',
  '/women/MuchAdo/', '/men/MuchAdo/'  ]
# gender == 1 both, 2 women, 3 men
mono_pages.each do |mono_page|
  monos, play = parse_monologues(server, mono_page)
  puts "#{play} had #{monos.size} monologes (#{mono_page})"
  insert_play(play)
  insert_monologues(server, mono_page, monos)
end
